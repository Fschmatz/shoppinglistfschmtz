import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFE5E4E6),
    colorScheme: ColorScheme.light(
        background: const Color(0xFFE5E4E6),
        primary: Colors.blueAccent,
        secondary: Colors.blueGrey.shade600
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFE5E4E6),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF050505)),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),
    scaffoldBackgroundColor: const Color(0xFFE5E4E6),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFE5E4E6),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFFE5E4E6),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFE5E5E5),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFE5E4E6),
    ),
    bottomAppBarColor: const Color(0xFFE5E4E6),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFFE5E4E6)));

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF2B2B2C),
    colorScheme: ColorScheme.dark(
        background: const Color(0xFF2B2B2C),
        primary: const Color(0xFF648bd1),
        secondary: Colors.blueGrey.shade600
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF2B2B2C),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFF5F5F5)),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF))),
    scaffoldBackgroundColor: const Color(0xFF2B2B2C),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF2B2B2C), //CARD COLOR
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
