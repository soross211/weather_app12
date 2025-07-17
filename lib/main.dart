import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart'; // Flutter material package
import 'weather_home_page.dart'; // Import the new weather home page

void main() {
  runApp(const MyApp()); // Start the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    // Root widget for the app
    return MaterialApp(
      title: 'Weather App', // App title
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent), // App color theme
        useMaterial3: true, // Use Material 3
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 32, letterSpacing: 1.2),
          displayMedium: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 36),
          titleLarge: TextStyle(color: Colors.blueGrey, fontSize: 22),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 8,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            backgroundColor: Colors.white.withOpacity(0.85),
            foregroundColor: Colors.blueAccent,
          ),
        ),
      ),
      home: const _GlassBackground(child: WeatherHomePage()), // Home page
    );
  }
}

class _GlassBackground extends StatelessWidget {
  final Widget child;
  const _GlassBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFB2FEFA),
                Color(0xFF6DD5ED),
                Color(0xFF2193b0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        child,
      ],
    );
  }
}
