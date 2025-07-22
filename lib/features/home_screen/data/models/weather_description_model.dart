import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_description_entity.dart';

class WeatherDescriptionModel extends WeatherDescriptionEntity {
  const WeatherDescriptionModel({
    required super.main,
    required super.description,
    required super.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'main': main,
      'description': description,
      'icon': icon,
    };
  }

  factory WeatherDescriptionModel.fromJson(Map<String, dynamic> json) {
    return WeatherDescriptionModel(
      main: json['main'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  WeatherDescriptionModel copyWith({
    String? main,
    String? description,
    String? icon,
  }) {
    return WeatherDescriptionModel(
      main: main ?? this.main,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }
}