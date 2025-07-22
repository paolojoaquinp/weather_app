import 'package:flutter/material.dart';
import 'package:flutter_weather_app/features/home_screen/presentation/home_screen.dart';
import 'package:flutter_weather_app/features/shared/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) =>  HomeScreen(),
      },
    );
  }
}