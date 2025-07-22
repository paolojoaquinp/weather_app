part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadWeatherData extends HomeEvent {
  final double latitude;
  final double longitude;

  const LoadWeatherData({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class RefreshWeatherData extends HomeEvent {
  final double latitude;
  final double longitude;

  const RefreshWeatherData({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}