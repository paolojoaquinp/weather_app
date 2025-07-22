import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/features/home_screen/data/repository_impl/weather_repository_impl.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/bloc/home_bloc.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/widgets/hourly_forecast_widget.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/widgets/weather_display_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(weatherRepository: WeatherRepositoryImpl())
        ..add(
          LoadWeatherData(latitude: 37.7749, longitude: -122.4194),
        ), // San Francisco coordinates as example
      child: _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeBlocError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4A4A8A),
                  Color(0xFF6B4A8A),
                  Color(0xFF8A4A8A),
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  _buildContent(context, state),
                  Positioned(child: BackButton(color: Colors.white)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    if (state is HomeBlocLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (state is HomeBlocError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 64),
            SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.message,
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(
                  RefreshWeatherData(latitude: 37.7749, longitude: -122.4194),
                );
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is HomeBlocLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          // get current location
          context.read<HomeBloc>().add(
            RefreshWeatherData(latitude: 37.7749, longitude: -122.4194),
          );
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: WeatherDisplayWidget(
                  weather: state.weather,
                  forecast: state.forecast,
                ),
              ),
              // Container(
              //   margin: EdgeInsets.all(16),
              //   child: HourlyForecastWidget(),
              // ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Text(
        'Welcome to Weather App',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
