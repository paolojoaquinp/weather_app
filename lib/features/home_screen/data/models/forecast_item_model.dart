import 'package:flutter_weather_app/features/home_screen/data/models/main_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/weather_description_model.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/forecast_entity.dart';

class ForecastItemModel extends ForecastItemEntity {
  const ForecastItemModel({
    required super.dt,
    required super.main,
    required super.weather,
  });

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'main': (main as MainModel).toJson(),
      'weather': weather.map((e) => (e as WeatherDescriptionModel).toJson()).toList(),
    };
  }

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) {
    return ForecastItemModel(
      dt: json['dt'] as int? ?? 0,
      main: MainModel.fromJson(json['main'] as Map<String, dynamic>? ?? {}),
      weather: (json['weather'] as List<dynamic>? ?? [])
          .map((e) => WeatherDescriptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ForecastItemModel copyWith({
    int? dt,
    MainModel? main,
    List<WeatherDescriptionModel>? weather,
  }) {
    return ForecastItemModel(
      dt: dt ?? this.dt,
      main: main ?? this.main as MainModel,
      weather: weather ?? this.weather.cast<WeatherDescriptionModel>(),
    );
  }
}