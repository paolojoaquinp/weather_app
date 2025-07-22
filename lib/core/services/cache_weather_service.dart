/// Configuración de caché para el repositorio
class CacheConfigService {
  final Duration weatherCacheDuration;
  final Duration forecastCacheDuration;
  final Duration maxStaleDuration;
  final bool enableCache;

  const CacheConfigService({
    this.weatherCacheDuration = const Duration(minutes: 15),
    this.forecastCacheDuration = const Duration(hours: 1),
    this.maxStaleDuration = const Duration(hours: 24),
    this.enableCache = true,
  });

  /// Configuración para desarrollo (caché más corto)
  static const dev = CacheConfigService(
    weatherCacheDuration: Duration(minutes: 5),
    forecastCacheDuration: Duration(minutes: 30),
    maxStaleDuration: Duration(hours: 6),
  );

  /// Configuración para producción (caché más largo)
  static const production = CacheConfigService(
    weatherCacheDuration: Duration(minutes: 30),
    forecastCacheDuration: Duration(hours: 2),
    maxStaleDuration: Duration(days: 1),
  );

  /// Configuración sin caché
  static const noCache = CacheConfigService(
    enableCache: false,
    weatherCacheDuration: Duration.zero,
    forecastCacheDuration: Duration.zero,
  );
}
