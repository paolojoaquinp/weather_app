import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E3A59), Color(0xFF6B4A9A), Color(0xFF8B5A96)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                // Weather Icon Placeholder
                Image.asset(
                  'assets/images/weather-icon.png',
                  fit: BoxFit.cover,
                ),
                // Title
                const Column(
                  children: [
                    Text(
                      'My Weather',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        // letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      'App',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFDD835),
                        // letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 1,),
                // Get Start Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle navigation
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDD835),
                      foregroundColor: const Color(0xFF2E3A59),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Get Start',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
