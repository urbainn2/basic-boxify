import 'package:flutter/material.dart';
import 'package:boxify/app_core.dart';

class BoxifyTheme {
  static ThemeData buildTheme() {
    return ThemeData.dark().copyWith(      
      scaffoldBackgroundColor: Core.appColor.scaffoldBackgroundColor,
      primaryColor: const Color.fromRGBO(30, 30, 30, 1),

      // Text theme with white text across all body text styles
      textTheme: ThemeData.dark().textTheme.copyWith(
        bodyLarge: const TextStyle(color: Colors.white),
        bodyMedium: const TextStyle(color: Colors.white),
        bodySmall: const TextStyle(color: Colors.white),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // White text on buttons
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, // White text on buttons
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, // White text on buttons
        ),
      ),

      iconTheme: const IconThemeData(color: Colors.white),  // White icons

      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromRGBO(30, 30, 30, 1), // AppBar background color
        iconTheme: const IconThemeData(color: Colors.white), // White icons in AppBar
      ),
    );
  }
}
