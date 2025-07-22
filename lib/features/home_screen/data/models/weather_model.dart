import 'package:flutter_weather_app/features/home_screen/data/models/main_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/sys_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/weather_description_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/wind_model.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.name,
    required super.sys,
    required super.main,
    required super.weather,
    required super.wind,
    this.isCurrentLocation,
  });

  final bool? isCurrentLocation;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sys': (sys as SysModel).toJson(),
      'main': (main as MainModel).toJson(),
      'weather': weather.map((e) => (e as WeatherDescriptionModel).toJson()).toList(),
      'wind': (wind as WindModel).toJson(),
    };
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['name'] as String? ?? '',
      sys: SysModel.fromJson(json['sys'] as Map<String, dynamic>? ?? {}),
      main: MainModel.fromJson(json['main'] as Map<String, dynamic>? ?? {}),
      weather: (json['weather'] as List<dynamic>? ?? [])
          .map((e) => WeatherDescriptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      wind: WindModel.fromJson(json['wind'] as Map<String, dynamic>? ?? {}),
    );
  }

  WeatherModel copyWith({
    String? name,
    SysModel? sys,
    MainModel? main,
    List<WeatherDescriptionModel>? weather,
    WindModel? wind,
    bool? isCurrentLocation,
  }) {
    return WeatherModel(
      name: name ?? this.name,
      sys: sys ?? this.sys as SysModel,
      main: main ?? this.main as MainModel,
      weather: weather ?? this.weather.cast<WeatherDescriptionModel>(),
      wind: wind ?? this.wind as WindModel,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
    );
  }
}