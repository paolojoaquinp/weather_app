import 'package:flutter_weather_app/features/home_screen/domain/entities/main_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/sys_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_description_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/wind_entity.dart';

class WeatherEntity {
  final String name;
  final SysEntity sys;
  final MainEntity main;
  final List<WeatherDescriptionEntity> weather;
  final WindEntity wind;

  const WeatherEntity({
    required this.name,
    required this.sys,
    required this.main,
    required this.weather,
    required this.wind,
  });
}
