import 'package:flutter_weather_app/features/home_screen/domain/entities/main_entity.dart';

class MainModel extends MainEntity {
  const MainModel({
    required super.temp,
    required super.feelsLike,
    required super.humidity,
  });

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'feels_like': feelsLike,
      'humidity': humidity,
    };
  }

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: json['humidity'] as int? ?? 0,
    );
  }

  MainModel copyWith({
    double? temp,
    double? feelsLike,
    int? humidity,
  }) {
    return MainModel(
      temp: temp ?? this.temp,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
    );
  }
}