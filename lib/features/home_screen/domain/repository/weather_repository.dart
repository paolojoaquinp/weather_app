import 'package:oxidized/oxidized.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/forecast_entity.dart';

abstract class WeatherRepository {
  Future<Result<WeatherEntity, String>> getCurrentWeather({
    required double lat,
    required double lng,
  });

  Future<Result<ForecastEntity, String>> getForecast({
    required double lat,
    required double lng,
  });
}