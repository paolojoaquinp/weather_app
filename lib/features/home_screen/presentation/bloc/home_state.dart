part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeBlocInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeBlocLoading extends HomeState {
  const HomeBlocLoading();
  
  @override
  List<Object> get props => [];
}

class HomeBlocLoaded extends HomeState {
  final WeatherModel weather;
  final ForecastModel forecast;

  const HomeBlocLoaded({
    required this.weather,
    required this.forecast,
  });

  @override
  List<Object> get props => [weather, forecast];
}

class HomeBlocError extends HomeState {
  final String message;

  const HomeBlocError({required this.message});

  @override
  List<Object> get props => [message];
}