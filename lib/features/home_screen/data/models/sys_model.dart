import 'package:flutter_weather_app/features/home_screen/domain/entities/sys_entity.dart';

class SysModel extends SysEntity {
  const SysModel({
    required super.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'country': country,
    };
  }

  factory SysModel.fromJson(Map<String, dynamic> json) {
    return SysModel(
      country: json['country'] as String? ?? '',
    );
  }

  SysModel copyWith({
    String? country,
  }) {
    return SysModel(
      country: country ?? this.country,
    );
  }
}