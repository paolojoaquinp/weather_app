import 'package:dio/dio.dart';
import 'package:flutter_weather_app/core/services/cache_weather_service.dart';
import 'package:oxidized/oxidized.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/forecast_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/repository/weather_repository.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/weather_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/forecast_model.dart';

/// Entry - caché simple
class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final Duration maxAge;

  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.maxAge,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > maxAge;
}

/// Caché - simple memory
class MemoryCache {
  static final Map<String, CacheEntry> _cache = {};

  static void put<T>(String key, T data, Duration maxAge) {
    _cache[key] = CacheEntry<T>(
      data: data,
      timestamp: DateTime.now(),
      maxAge: maxAge,
    );
  }

  static T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null || entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.data as T?;
  }

  static void remove(String key) {
    _cache.remove(key);
  }

  static void clear() {
    _cache.clear();
  }

  static bool containsKey(String key) {
    final entry = _cache[key];
    if (entry?.isExpired == true) {
      _cache.remove(key);
      return false;
    }
    return entry != null;
  }
}

class WeatherRepositoryImpl implements WeatherRepository {
  final Dio _dio;
  final String _apiKey;
  final CacheConfigService _cacheConfig;

  WeatherRepositoryImpl({
    Dio? dio,
    String? apiKey,
    CacheConfigService? cacheConfig,
  }) : _dio = dio ?? _createDefaultDio(),
       _apiKey = apiKey ?? '3082cbfe90c06992aecd2caffae913ef',
       _cacheConfig = cacheConfig ?? const CacheConfigService();

  static Dio _createDefaultDio() {
    final dio = Dio();
    dio.options.baseUrl = 'http://api.openweathermap.org/data/2.5';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Content-Type': 'application/json',
    };

    // Logging interceptor
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      logPrint: (obj) => print(obj),
    ));

    return dio;
  }

  @override
  Future<Result<WeatherEntity, String>> getCurrentWeather({
    required double lat,
    required double lng,
    bool forceRefresh = false,
    Duration? customCacheDuration,
  }) async {
    final cacheDuration = customCacheDuration ?? _cacheConfig.weatherCacheDuration;
    final cacheKey = _buildCacheKey('weather', lat, lng);

    if (_cacheConfig.enableCache && !forceRefresh) {
      final cachedData = MemoryCache.get<WeatherEntity>(cacheKey);
      if (cachedData != null) {
        return Ok(cachedData);
      }
    }

    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final weatherModel = WeatherModel.fromJson(response.data);
        
        // Guardar en caché si está habilitado
        if (_cacheConfig.enableCache) {
          MemoryCache.put(cacheKey, weatherModel, cacheDuration);
        }
        
        return Ok(weatherModel);
      } else {
        return Err('Failed to load weather data: Invalid response');
      }
    } on DioException catch (e) {
      // En caso de error, intentar usar caché como fallback
      if (_cacheConfig.enableCache) {
        final cachedData = MemoryCache.get<WeatherEntity>(cacheKey);
        if (cachedData != null) {
          return Ok(cachedData);
        }
      }
      
      final errorMessage = _handleDioException(e, 'current weather');
      return Err(errorMessage);
    } catch (e) {
      return Err('Unexpected error fetching current weather: $e');
    }
  }

  @override
  Future<Result<ForecastEntity, String>> getForecast({
    required double lat,
    required double lng,
    bool forceRefresh = false,
    Duration? customCacheDuration,
  }) async {
    final cacheDuration = customCacheDuration ?? _cacheConfig.forecastCacheDuration;
    final cacheKey = _buildCacheKey('forecast', lat, lng);

    // Verificar caché si está habilitado y no es refresh forzado
    if (_cacheConfig.enableCache && !forceRefresh) {
      final cachedData = MemoryCache.get<ForecastEntity>(cacheKey);
      if (cachedData != null) {
        return Ok(cachedData);
      }
    }

    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final forecastModel = ForecastModel.fromJson(response.data);
        
        // Guardar en caché si está habilitado
        if (_cacheConfig.enableCache) {
          MemoryCache.put(cacheKey, forecastModel, cacheDuration);
        }
        
        return Ok(forecastModel);
      } else {
        return Err('Failed to load forecast data: Invalid response');
      }
    } on DioException catch (e) {
      // En caso de error, intentar usar caché como fallback
      if (_cacheConfig.enableCache) {
        final cachedData = MemoryCache.get<ForecastEntity>(cacheKey);
        if (cachedData != null) {
          return Ok(cachedData);
        }
      }
      
      final errorMessage = _handleDioException(e, 'forecast');
      return Err(errorMessage);
    } catch (e) {
      return Err('Unexpected error fetching forecast: $e');
    }
  }

  String _buildCacheKey(String endpoint, double lat, double lng) {
    return '${endpoint}_${lat}_${lng}';
  }

  /// Obtiene información del caché actual
  Future<Map<String, dynamic>> getCacheInfo() async {
    return {
      'enabled': _cacheConfig.enableCache,
      'weatherCacheDuration': _cacheConfig.weatherCacheDuration.inMinutes,
      'forecastCacheDuration': _cacheConfig.forecastCacheDuration.inHours,
      'maxStaleDuration': _cacheConfig.maxStaleDuration.inHours,
    };
  }

  /// Limpia todo el caché
  Future<void> clearAllCache() async {
    MemoryCache.clear();
  }

  /// Limpia caché para una ubicación específica
  Future<void> clearLocationCache({
    required double lat,
    required double lng,
  }) async {
    final weatherKey = _buildCacheKey('weather', lat, lng);
    final forecastKey = _buildCacheKey('forecast', lat, lng);
    
    MemoryCache.remove(weatherKey);
    MemoryCache.remove(forecastKey);
  }

  /// Verifica si hay datos en caché para una ubicación
  Future<bool> hasCachedData({
    required double lat,
    required double lng,
  }) async {
    final weatherKey = _buildCacheKey('weather', lat, lng);
    return MemoryCache.containsKey(weatherKey);
  }

  String _handleDioException(DioException e, String operation) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout - Check your internet connection';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout - Server is not responding';
      case DioExceptionType.sendTimeout:
        return 'Send timeout - Request took too long';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return 'Bad request - Invalid coordinates';
          case 401:
            return 'Invalid API key';
          case 404:
            return 'Location not found';
          case 429:
            return 'API rate limit exceeded';
          case 500:
            return 'Server error - Try again later';
          default:
            return 'Server error ($statusCode) for $operation';
        }
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.unknown:
        return 'Network error - Check your internet connection';
      default:
        return 'Network error fetching $operation: ${e.message}';
    }
  }
}