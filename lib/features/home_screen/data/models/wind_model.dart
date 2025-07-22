import 'package:flutter_weather_app/features/home_screen/domain/entities/wind_entity.dart';

class WindModel extends WindEntity {
  const WindModel({
    required super.speed,
  });

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
    };
  }

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }

  WindModel copyWith({
    double? speed,
  }) {
    return WindModel(
      speed: speed ?? this.speed,
    );
  }
}