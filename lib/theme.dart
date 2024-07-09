import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF3A5F9A),
    primaryColorLight: Color(0xFF6D90C6),
    primaryColorDark: Color(0xFF1A3A6C),
    scaffoldBackgroundColor: Color(0xFFF5F7FA),
    cardColor: Color(0xFFFFFFFF),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3A5F9A),
      secondary: Color(0xFFFFD700),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
          color: Color(0xFF1A3A6C), fontSize: 18, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Color(0xFF333333)),
      bodySmall: TextStyle(color: Color(0xFF666666)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(83, 142, 157, 209),
      iconTheme: IconThemeData(color: Color(0xFF1A3A6C)),
      titleTextStyle: TextStyle(
          color: Color(0xFF1A3A6C), fontWeight: FontWeight.bold, fontSize: 28),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 225, 230, 246),
    primaryColorLight: Color(0xFF36A8B0),
    primaryColorDark: Color.fromARGB(255, 8, 43, 97),
    scaffoldBackgroundColor: Color(0xFF121212),
    cardColor: Color.fromARGB(255, 15, 20, 31),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1A3A6C),
      secondary: Color(0xFFFFD700),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
          color: Color.fromARGB(255, 238, 238, 238),
          fontSize: 18,
          fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Color.fromARGB(255, 238, 238, 238)),
      bodySmall: TextStyle(color: Color.fromARGB(255, 177, 177, 177)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0x33E1E6F6),
      iconTheme: IconThemeData(color: Color.fromARGB(255, 225, 230, 246)),
      titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 225, 230, 246),
          fontWeight: FontWeight.bold,
          fontSize: 28),
    ),
  );

  static List<Color> lightBackgroundGradient = [
    Color(0xFFF5F7FA),
    Color(0xFFE1E6F6),
    Color(0xFFD1DBEF),
  ];

  static List<Color> darkBackgroundGradient = [
    Color.fromARGB(255, 1, 4, 31),
    Color.fromARGB(255, 11, 22, 41),
    Color.fromARGB(255, 1, 4, 21),
  ];

  static List<Color> lightButtonGradient = [
    Color(0xFF3A5F9A),
    Color(0xFF1A3A6C),
  ];

  static List<Color> darkButtonGradient = [
    Color.fromARGB(255, 13, 28, 60),
    Color.fromARGB(255, 0, 21, 57)
  ];

  static List<Color> darkipoCardBackgroundGradient = [
    Color.fromARGB(255, 15, 20, 31),
    Color.fromARGB(255, 4, 12, 24)
  ];

  static List<Color> lightipoCardBackgroundGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF0F4F8),
  ];
}
