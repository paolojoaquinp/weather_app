import 'package:flutter/material.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/widgets/hourly_forecast_widget.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/widgets/weather_display_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: WeatherDisplayWidget(),
              ),
              // Container(
              //   margin: EdgeInsets.all(16),
              //   child: HourlyForecastWidget(),
              // ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}