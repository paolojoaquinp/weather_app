import 'package:flutter/material.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/forecast_model.dart';
import 'package:flutter_weather_app/features/home_screen/data/models/weather_model.dart';

class WeatherDisplayWidget extends StatelessWidget {
  const WeatherDisplayWidget({
    super.key,
    required this.weather,
    required this.forecast,
  });

  final WeatherModel weather;
  final ForecastModel forecast;

  @override
  Widget build(BuildContext context) {
    // Obtener el primer item de la descripción del clima
    final weatherDescription = weather.weather.isNotEmpty 
        ? weather.weather.first 
        : null;

    // Obtener temperaturas min/max del primer item del forecast
    final firstForecastItem = forecast.list.isNotEmpty 
        ? forecast.list.first 
        : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Weather Icon and Animation
        Image.asset(
          _getWeatherIcon(weatherDescription?.main ?? 'clear'),
          height: 300,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.cloud,
              size: 300,
              color: Colors.white.withOpacity(0.8),
            );
          },
        ),
        SizedBox(height: 20),
        // Temperature
        Text(
          '${weather.main.temp.round()}°',
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 0.8,
          ),
        ),
        SizedBox(height: 10),
        // Weather Location
        Text(
          '${weather.name}, ${weather.sys.country}',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        // Description
        Text(
          weatherDescription?.description ?? 'No description',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8),
        // Min/Max Temperature
        Text(
          'Temp: ${weather.main.temp.round()}°',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 16),
        // Additional weather info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildWeatherInfo(
              icon: Icons.water_drop,
              label: 'Humidity',
              value: '${weather.main.humidity}%',
            ),
            _buildWeatherInfo(
              icon: Icons.air,
              label: 'Wind',
              value: '${weather.wind.speed.toStringAsFixed(1)} m/s',
            ),
            _buildWeatherInfo(
              icon: Icons.thermostat,
              label: 'Feels like',
              value: '${weather.main.feelsLike.round()}°',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'assets/images/sunny.png';
      case 'rain':
      case 'drizzle':
        return 'assets/images/rainy.png';
      case 'snow':
        return 'assets/images/snowy.png';
      case 'clouds':
        return 'assets/images/cloudy.png';
      case 'thunderstorm':
        return 'assets/images/thunderstorm.png';
      default:
        return 'assets/images/weather-icon.png';
    }
  }
}