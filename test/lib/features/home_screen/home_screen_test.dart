import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/forecast_item_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/forecast_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/main_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/sys_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/weather_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/wind_model.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/forecast_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_description_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/entities/weather_entity.dart';
import 'package:flutter_weather_app/features/home_screen/domain/repository/weather_repository.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/bloc/home_bloc.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/home_screen.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/widgets/weather_display_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([WeatherRepository])
void main() {
  // Proporcionar valores dummy para Mockito
  setUpAll(() {
    provideDummy<Result<WeatherEntity, String>>(const Err('dummy'));
    provideDummy<Result<ForecastEntity, String>>(const Err('dummy'));
  });

  group('HomeScreen Tests', () {
    late MockWeatherRepository mockWeatherRepository;

    setUp(() {
      mockWeatherRepository = MockWeatherRepository();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<HomeBloc>(
          create: (context) =>
              HomeBloc(weatherRepository: mockWeatherRepository),
          child: const HomeScreen(),
        ),
      );
    }

    group('HomeBloc Tests', () {
      late HomeBloc homeBloc;

      setUp(() {
        homeBloc = HomeBloc(weatherRepository: mockWeatherRepository);
      });

      tearDown(() {
        homeBloc.close();
      });

      final mockWeather = WeatherModel(
        name: 'Test City',
        sys: SysModel(
          country: 'US',
        ),
        main: MainModel(
          temp: 20.0,
          feelsLike: 22.0,
          humidity: 60,
        ),
        weather: [
          WeatherDescriptionEntity(
            main: 'Clear',
            description: 'clear sky',
            icon: '01d',
          ),
        ],
        wind: WindModel(speed: 2.5),
      );

      final mockForecast = ForecastModel(
        list: [
          ForecastItemModel(
            dt: 1,
            main: MainModel(temp: 18.0, feelsLike: 20.0, humidity: 65),
            weather: [
              WeatherDescriptionEntity(
                main: 'Clouds',
                description: 'scattered clouds',
                icon: '03d',
              ),
            ],
          ),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeBlocLoading, HomeBlocLoaded] when LoadWeatherData is successful',
        build: () {
          when(
            mockWeatherRepository.getCurrentWeather(
              lat: anyNamed('lat'),
              lng: anyNamed('lng'),
              forceRefresh: anyNamed('forceRefresh'),
              customCacheDuration: anyNamed('customCacheDuration'),
            ),
          ).thenAnswer((_) async => Ok(mockWeather));

          when(
            mockWeatherRepository.getForecast(
              lat: anyNamed('lat'),
              lng: anyNamed('lng'),
            ),
          ).thenAnswer((_) async => Ok(mockForecast));

          return homeBloc;
        },
        act: (bloc) => bloc.add(
          const LoadWeatherData(latitude: 37.7749, longitude: -122.4194),
        ),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const HomeBlocLoading(),
          HomeBlocLoaded(weather: mockWeather, forecast: mockForecast),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeBlocLoading, HomeBlocError] when weather fetch fails',
        build: () {
          when(
            mockWeatherRepository.getCurrentWeather(
              lat: anyNamed('lat'),
              lng: anyNamed('lng'),
              forceRefresh: anyNamed('forceRefresh'),
              customCacheDuration: anyNamed('customCacheDuration'),
            ),
          ).thenAnswer((_) async => const Err('Weather fetch failed'));

          when(
            mockWeatherRepository.getForecast(
              lat: anyNamed('lat'),
              lng: anyNamed('lng'),
            ),
          ).thenAnswer((_) async => Ok(mockForecast));

          return homeBloc;
        },
        act: (bloc) => bloc.add(
          const LoadWeatherData(latitude: 37.7749, longitude: -122.4194),
        ),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const HomeBlocLoading(),
          const HomeBlocError(message: 'Weather fetch failed'),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeBlocLoading, HomeBlocError] when forecast fetch fails',
        build: () {
          when(
            mockWeatherRepository.getCurrentWeather(
              lat: anyNamed('lat'),
              lng: anyNamed('lng'),
              forceRefresh: anyNamed('forceRefresh'),
              customCacheDuration: anyNamed('customCacheDuration'),
            ),
          ).thenAnswer((_) async => Ok(mockWeather));

          when(
            mockWeatherRepository.getForecast(
              lat: anyNamed('lat'),
              lng: anyNamed('lng'),
            ),
          ).thenAnswer((_) async => const Err('Forecast fetch failed'));

          return homeBloc;
        },
        act: (bloc) => bloc.add(
          const LoadWeatherData(latitude: 37.7749, longitude: -122.4194),
        ),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const HomeBlocLoading(),
          const HomeBlocError(message: 'Forecast fetch failed'),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeBlocLoading, HomeBlocLoaded] when RefreshWeatherData is successful',
        build: () {
          when(
            mockWeatherRepository.getCurrentWeather(
              lat: anyNamed('lat'),
              lng: anyNamed('lng'),
              forceRefresh: anyNamed('forceRefresh'),
              customCacheDuration: anyNamed('customCacheDuration'),
            ),
          ).thenAnswer((_) async => Ok(mockWeather));

          when(
            mockWeatherRepository.getForecast(
              lat: anyNamed('lat'),
              lng: anyNamed('lng'),
            ),
          ).thenAnswer((_) async => Ok(mockForecast));

          return homeBloc;
        },
        act: (bloc) => bloc.add(
          const RefreshWeatherData(latitude: 37.7749, longitude: -122.4194),
        ),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const HomeBlocLoading(),
          HomeBlocLoaded(weather: mockWeather, forecast: mockForecast),
        ],
      );
    });

    group('Widget Tests', () {
      testWidgets('displays loading when HomeScreen starts', (tester) async {
        when(
          mockWeatherRepository.getCurrentWeather(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
            forceRefresh: anyNamed('forceRefresh'),
            customCacheDuration: anyNamed('customCacheDuration'),
          ),
        ).thenAnswer(
          (_) async => Future.delayed(
            const Duration(seconds: 1),
            () => const Err('Error'),
          ),
        );

        when(
          mockWeatherRepository.getForecast(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
          ),
        ).thenAnswer((_) async => const Err('Error'));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('displays error UI when data fetch fails', (tester) async {
        when(
          mockWeatherRepository.getCurrentWeather(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
            forceRefresh: anyNamed('forceRefresh'),
            customCacheDuration: anyNamed('customCacheDuration'),
          ),
        ).thenAnswer((_) async => const Err('Network error'));

        when(
          mockWeatherRepository.getForecast(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
          ),
        ).thenAnswer((_) async => const Err('Network error'));

        await tester.pumpWidget(createWidgetUnderTest());
        // Use pump with a timeout instead of pumpAndSettle
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Something went wrong'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('displays weather data when successfully loaded', (
        tester,
      ) async {
        final mockWeather = WeatherModel(
          name: 'San Francisco',
          sys: SysModel(country: 'US'),
          main: MainModel(temp: 22.5, feelsLike: 25.0, humidity: 65),
          weather: [
            WeatherDescriptionEntity(
              main: 'Clear',
              description: 'clear sky',
              icon: '01d',
            ),
          ],
          wind: WindModel(speed: 3.5),
        );

        final mockForecast = ForecastModel(list: []);

        when(
          mockWeatherRepository.getCurrentWeather(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
            forceRefresh: anyNamed('forceRefresh'),
            customCacheDuration: anyNamed('customCacheDuration'),
          ),
        ).thenAnswer((_) async => Ok(mockWeather));

        when(
          mockWeatherRepository.getForecast(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
          ),
        ).thenAnswer((_) async => Ok(mockForecast));

        await tester.pumpWidget(createWidgetUnderTest());
        // Use pump with a timeout instead of pumpAndSettle
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(WeatherDisplayWidget), findsOneWidget);
        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('retry button works correctly', (tester) async {
        when(
          mockWeatherRepository.getCurrentWeather(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
            forceRefresh: anyNamed('forceRefresh'),
            customCacheDuration: anyNamed('customCacheDuration'),
          ),
        ).thenAnswer((_) async => const Err('Network error'));

        when(
          mockWeatherRepository.getForecast(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
          ),
        ).thenAnswer((_) async => const Err('Network error'));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Retry'), findsOneWidget);

        await tester.tap(find.text('Retry'));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('has gradient background', (tester) async {
        when(
          mockWeatherRepository.getCurrentWeather(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
            forceRefresh: anyNamed('forceRefresh'),
            customCacheDuration: anyNamed('customCacheDuration'),
          ),
        ).thenAnswer((_) async => const Err('Error'));

        when(
          mockWeatherRepository.getForecast(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
          ),
        ).thenAnswer((_) async => const Err('Error'));

        await tester.pumpWidget(createWidgetUnderTest());

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );

        expect(container.decoration, isA<BoxDecoration>());
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.gradient, isA<LinearGradient>());
      });

      testWidgets('has back button', (tester) async {
        when(
          mockWeatherRepository.getCurrentWeather(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
            forceRefresh: anyNamed('forceRefresh'),
            customCacheDuration: anyNamed('customCacheDuration'),
          ),
        ).thenAnswer((_) async => const Err('Error'));

        when(
          mockWeatherRepository.getForecast(
            lat: anyNamed('lat'),
            lng: anyNamed('lng'),
          ),
        ).thenAnswer((_) async => const Err('Error'));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(BackButton), findsOneWidget);
      });
    });
  });
}