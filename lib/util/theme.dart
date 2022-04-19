import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFEEEEEE),
    colorScheme: ColorScheme.light(
        background: const Color(0xFFEEEEEE),
        primary: Colors.blueAccent.shade700,
        secondary: Colors.grey,
        tertiary: const Color(0xFFFF5C78)
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFEEEEEE),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF000000)),
        titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Color(0xFF000000))),
    scaffoldBackgroundColor: const Color(0xFFEEEEEE),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFEEEEEE),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFFF9F9F9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFE5E5E5),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFEEEEEE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
    ),
    bottomAppBarColor: const Color(0xFFEEEEEE),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFFEEEEEE)));

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF2B2B2C),
    colorScheme: ColorScheme.dark(
        background: const Color(0xFF2B2B2C),
        primary: const Color(0xFF648bd1),
        secondary: Colors.grey.shade600,
        tertiary: const Color(0xFFEA8294)
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF2B2B2C),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFFFFFF))),
    scaffoldBackgroundColor: const Color(0xFF2B2B2C),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF2B2B2C),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFF343435),//0xFF2B2B2C
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF383839),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF202022),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF2B2B2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
    ),
    bottomAppBarColor: const Color(0xFF2B2B2C),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFF2B2B2C)));
