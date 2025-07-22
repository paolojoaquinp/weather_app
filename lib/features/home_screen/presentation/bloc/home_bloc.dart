import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/forecast_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/weather_model.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/forecast_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/repository/weather_repository.dart';
import 'package:location/location.dart';
import 'package:oxidized/oxidized.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required WeatherRepository weatherRepository,
  }) : _weatherRepository = weatherRepository , super(HomeBlocInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadWeatherData>(_onLoadWeatherData);
    on<RefreshWeatherData>(_onRefreshWeatherData);
  }

  final WeatherRepository _weatherRepository;

    Future<void> _onLoadWeatherData(
    LoadWeatherData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeBlocLoading());
    await _fetchWeatherData(event.latitude, event.longitude, emit);
  }

  Future<void> _onRefreshWeatherData(
    RefreshWeatherData event,
    Emitter<HomeState> emit,
  ) async {
    await _fetchWeatherData(event.latitude, event.longitude, emit);
  }

  Future<void> _fetchWeatherData(
    double latitude,
    double longitude,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeBlocLoading());
    // fetch latitude and longitude from location service
    final location = Location();

    try {
      final hasPermission = await location.hasPermission();
      if (hasPermission != PermissionStatus.granted) {
        final permissionStatus = await location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          emit(HomeBlocError(message: 'Location permission denied'));
          return;
        }
      }
      final hasServiceEnabled = await location.serviceEnabled();
      if (!hasServiceEnabled) {
        final serviceStatus = await location.requestService();
        if (!serviceStatus) {
          emit(HomeBlocError(message: 'Location service is disabled'));
          return;
        }
      }
      final getLocation = await location.getLocation();
      latitude = getLocation.latitude ?? latitude;
      longitude = getLocation.longitude ?? longitude;
      final Result<WeatherEntity, String>  weatherResult = await _weatherRepository.getCurrentWeather(
        lat: latitude,
        lng: longitude,
      );

      final Result<ForecastEntity, String>  forecastResult = await _weatherRepository.getForecast(
        lat: latitude,
        lng: longitude,
      );

      if (weatherResult.isOk() && forecastResult.isOk()) {
        final WeatherModel weather = weatherResult.unwrap() as WeatherModel;
        final ForecastModel forecast = forecastResult.unwrap() as ForecastModel;
        // Optionally, you can set the isCurrentLocation flag if needed
        
        emit(HomeBlocLoaded(
          // weather: weatherResult.unwrap(),
          weather: weather,
          // forecast: forecastResult.unwrap(),
          forecast: forecast,
        ));
      } else {
        final weatherError = weatherResult.isErr() ? weatherResult.unwrapErr() : '';
        final forecastError = forecastResult.isErr() ? forecastResult.unwrapErr() : '';
        final errorMessage = weatherError.isNotEmpty ? weatherError : forecastError;
        emit(HomeBlocError(message: errorMessage));
      }
    } catch (e) {
      emit(HomeBlocError(message: 'Unexpected error: $e'));
    }
  }
}
