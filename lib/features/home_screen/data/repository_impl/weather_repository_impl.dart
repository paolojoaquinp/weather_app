import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/forecast_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/repository/weather_repository.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/weather_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/forecast_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final Dio _dio;
  final String _apiKey;

  WeatherRepositoryImpl({
    Dio? dio,
    String? apiKey,
  }) : _dio = dio ?? _createDefaultDio(),
       _apiKey = apiKey ?? '3082cbfe90c06992aecd2caffae913ef';

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
  }) async {
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
        return Ok(weatherModel);
      } else {
        return Err('Failed to load weather data: Invalid response');
      }
    } on DioException catch (e) {
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
  }) async {
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
        return Ok(forecastModel);
      } else {
        return Err('Failed to load forecast data: Invalid response');
      }
    } on DioException catch (e) {
      final errorMessage = _handleDioException(e, 'forecast');
      return Err(errorMessage);
    } catch (e) {
      return Err('Unexpected error fetching forecast: $e');
    }
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