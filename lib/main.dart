import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark, // Mid-tone dark mode
        // Primary Colors
        primaryColor: const Color(0xFF37474F), // Unified background color
        scaffoldBackgroundColor: const Color(0xFF37474F), // Deep cool gray
        // AppBar Theme (Same color as background)
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF37474F), // Matches background
          elevation: 0, // No shadow for a seamless look
          shadowColor: Colors.transparent,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white, size: 28),
        ),

        // General Text Theme
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.white.withAlpha(230),
          displayColor: Colors.white70,
        ),

        // Icon Theme
        iconTheme: const IconThemeData(
          color: Color.fromARGB(211, 255, 255, 255),
          size: 30,
        ),

        // Card Theme - Glass effect with soft contrast
        cardTheme: CardTheme(
          color: const Color.fromARGB(230, 37, 37, 37), // Glassmorphic blue-gray
          elevation: 6,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF607D8B), // Muted blue
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            elevation: 3,
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFA726), // Warm accent (sun-like orange)
          elevation: 5,
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(
            0xFF455A64,
          ).withValues(alpha: 220, red: 69, green: 90, blue: 100),
          selectedItemColor: const Color(0xFFFFA726), // Warm accent
          unselectedItemColor: Colors.white70,
          elevation: 8,
          showUnselectedLabels: true,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const WeatherApp(),
    );
  }
}
