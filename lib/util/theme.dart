import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w400),
    ),
    primaryColor: const Color(0xFFF4F0F4),
    colorScheme: ColorScheme.light(
        background: const Color(0xFFF4F0F4),
        primary: Colors.blueAccent.shade700,
        secondary: Colors.grey,
        tertiary: const Color(0xFFFF5C78)),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Color(0xFFF4F0F4),
      color: Color(0xFFF4F0F4),
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F0F4),
    inputDecorationTheme: const InputDecorationTheme(
    //  fillColor: Color(0xFFF4F0F4),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFFFBFBFB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
    cardTheme: const CardTheme(
      surfaceTintColor: Color(0xFFFFFBFF),
      color: Color(0xFFFFFBFF),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFE5E5E5),
    ),
    dialogTheme:
        const DialogTheme(backgroundColor: Color(0xFFF4F0F4), elevation: 1),
    bottomAppBarColor: const Color(0xFFF4F0F4),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFFF4F0F4)));

ThemeData dark = ThemeData(
    useMaterial3: true,
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w400),
    ),
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF252525),
    colorScheme: ColorScheme.dark(
        background: const Color(0xFF252525),
        primary: const Color(0xFF648bd1),
        secondary: Colors.grey.shade600,
        tertiary: const Color(0xFFEA8294)),
    appBarTheme: const AppBarTheme(
        surfaceTintColor: Color(0xFF252525), color: Color(0xFF252525)),
    scaffoldBackgroundColor: const Color(0xFF252525),
    inputDecorationTheme: const InputDecorationTheme(
     //fillColor: Color(0xFF252525),
    ),
    cardTheme: const CardTheme(
      surfaceTintColor: Color(0xFF343435),
      color: Color(0xFF343435),
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
      backgroundColor: Color(0xFF252525),
    ),
    bottomAppBarColor: const Color(0xFF252525),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFF252525)));
