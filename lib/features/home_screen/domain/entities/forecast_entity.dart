import 'package:flutter_weather_app/features/home_screen/domain/entities/main_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_description_entity.dart';

class ForecastEntity {
  final List<ForecastItemEntity> list;

  const ForecastEntity({
    required this.list,
  });
}

class ForecastItemEntity {
  final int dt;
  final MainEntity main;
  final List<WeatherDescriptionEntity> weather;

  const ForecastItemEntity({
    required this.dt,
    required this.main,
    required this.weather,
  });
}