import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String temperature;
  final String time;
  final WeatherIcon icon;

  const HourlyForecastItem({
    super.key,
    required this.temperature,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          temperature,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          child: _buildWeatherIcon(),
        ),
        SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon() {
    switch (icon) {
      case WeatherIcon.partlyCloudy:
        return Stack(
          children: [
            Positioned(
              right: 0,
              top: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 24,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      case WeatherIcon.cloudy:
      default:
        return Container(
          width: 28,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        );
    }
  }
}

enum WeatherIcon {
  partlyCloudy,
  cloudy,
}