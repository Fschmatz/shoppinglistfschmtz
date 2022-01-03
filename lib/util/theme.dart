import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    primaryColor: const Color(0xFFECEBEB),
    colorScheme: ColorScheme.light(
        background: const Color(0xFFECEBEB),
        primary: Colors.blueAccent,
        secondary: Colors.blueGrey.shade600,
        secondaryVariant: Colors.blueAccent,),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFECEBEB),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF050505)),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),
    scaffoldBackgroundColor: const Color(0xFFECEBEB),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFECEBEB),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFFECEBEB),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFE5E5E5),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFECEBEB),
    ),
    bottomAppBarColor: const Color(0xFFECEBEB),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFFECEBEB)));

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColorBrightness: Brightness.light,
    primaryColor: const Color(0xFF2B2B2C),
    colorScheme: ColorScheme.dark(
        background: const Color(0xFF2B2B2C),
        primary: const Color(0xFF648bd1),
        secondary: Colors.blueGrey.shade600,
        secondaryVariant: const Color(0xFF648bd1)),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF2B2B2C),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFEAEAEA)),
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

class ThemeNotifier extends ChangeNotifier {
  final String key = 'valorTema';
  SharedPreferences prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(key, _darkTheme);
  }
}
