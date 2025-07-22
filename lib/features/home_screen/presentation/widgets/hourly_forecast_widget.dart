import 'package:flutter/material.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/widgets/hourly_forecast_item.dart';

class HourlyForecastWidget extends StatelessWidget {
  const HourlyForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8, bottom: 12),
            child: Row(
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Text(
                  'July, 21',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HourlyForecastItem(
                temperature: '19°C',
                time: '15.00',
                icon: WeatherIcon.partlyCloudy,
              ),
              HourlyForecastItem(
                temperature: '18°C',
                time: '16.00',
                icon: WeatherIcon.cloudy,
              ),
              HourlyForecastItem(
                temperature: '18°C',
                time: '17.00',
                icon: WeatherIcon.cloudy,
              ),
              HourlyForecastItem(
                temperature: '18°C',
                time: '18.00',
                icon: WeatherIcon.cloudy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

