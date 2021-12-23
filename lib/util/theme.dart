import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    primaryColor: const Color(0xFFFFFFFF),
    accentColor: Colors.blueAccent,
    appBarTheme: const AppBarTheme(
        color: Color(0xFFFFFFFF),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFF050505)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFFFFFFF),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFFFFFFFF),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFE5E5E5),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFFFFFFF),
    ),
    bottomAppBarColor: const Color(0xFFFFFFFF),
    bottomSheetTheme:
    const BottomSheetThemeData(modalBackgroundColor: Color(0xFFFFFFFF)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColorBrightness: Brightness.light,
    primaryColor: const Color(0xFF242426),
    accentColor: const Color(0xFF6B89BF),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF242426),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFFCACACA)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF))),
    scaffoldBackgroundColor: const Color(0xFF242426),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF323234), //CARD COLOR
    ),
    cardTheme: const CardTheme(
      color: Color(0xFF323234),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF202022),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF242426),
    ),
    bottomAppBarColor: const Color(0xFF242426),
    bottomSheetTheme:
    const BottomSheetThemeData(modalBackgroundColor: Color(0xFF242426)));

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
