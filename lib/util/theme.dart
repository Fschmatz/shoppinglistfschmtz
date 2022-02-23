import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFE9E9E9),
    colorScheme: ColorScheme.light(
        background: const Color(0xFFE9E9E9),
        primary: Colors.blueAccent,
        secondary: Colors.blueGrey.shade600,
        tertiary: const Color(0xFFFF5C78)
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFE9E9E9),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF000000)),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),
    scaffoldBackgroundColor: const Color(0xFFE9E9E9),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFE9E9E9),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFFE9E9E9),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFE5E5E5),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFE9E9E9),
    ),
    bottomAppBarColor: const Color(0xFFE9E9E9),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFFE9E9E9)));

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF2B2B2C),
    colorScheme: ColorScheme.dark(
        background: const Color(0xFF2B2B2C),
        primary: const Color(0xFF648bd1),
        secondary: Colors.blueGrey.shade600,
        tertiary: const Color(0xFFFF5C78)
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF2B2B2C),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF))),
    scaffoldBackgroundColor: const Color(0xFF2B2B2C),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF2B2B2C),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFF2B2B2C),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF202022),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF2B2B2C),
    ),
    bottomAppBarColor: const Color(0xFF2B2B2C),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFF2B2B2C)));
