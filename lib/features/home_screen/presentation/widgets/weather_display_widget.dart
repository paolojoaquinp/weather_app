import 'package:flutter/material.dart';

class WeatherDisplayWidget extends StatelessWidget {
  const WeatherDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Weather Icon and Animation
        Image.asset(
          'assets/images/weather-icon.png',
          height: 300,
        ),
        SizedBox(height: 20),
        // Temperature
        Text(
          '19°',
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 0.8,
          ),
        ),
        SizedBox(height: 10),
        // Description
        Text(
          'Precipitations',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8),
        // Min/Max Temperature
        Text(
          'Max: 24°  Min:18°',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

