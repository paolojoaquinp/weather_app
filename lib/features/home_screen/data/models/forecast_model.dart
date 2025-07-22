import 'package:flutter_weather_app/features/home_screen/data/models/forecast_item_model.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/forecast_entity.dart';
import 'weather_model.dart';

class ForecastModel extends ForecastEntity {
  const ForecastModel({
    required super.list,
    this.isFromCache,
  });

  final bool? isFromCache;

  Map<String, dynamic> toJson() {
    return {
      'list': list.map((e) => (e as ForecastItemModel).toJson()).toList(),
    };
  }

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      list: (json['list'] as List<dynamic>? ?? [])
          .map((e) => ForecastItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ForecastModel copyWith({
    List<ForecastItemModel>? list,
    bool? isFromCache,
  }) {
    return ForecastModel(
      list: list ?? this.list.cast<ForecastItemModel>(),
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}