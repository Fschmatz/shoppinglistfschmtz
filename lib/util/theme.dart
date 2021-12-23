import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    primaryColor: const Color(0xFFF2F0F0),
    accentColor: Colors.blueAccent,
    appBarTheme: const AppBarTheme(
        color: Color(0xFFF2F0F0),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFF050505)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),
    scaffoldBackgroundColor: const Color(0xFFF2F0F0),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFF2F0F0),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFFF2F0F0),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFE5E5E5),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFF2F0F0),
    ),
    bottomAppBarColor: const Color(0xFFF2F0F0),
    bottomSheetTheme:
    const BottomSheetThemeData(modalBackgroundColor: Color(0xFFF2F0F0)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColorBrightness: Brightness.light,
    primaryColor: const Color(0xFF2B2B2D),
    accentColor: const Color(0xFF6B89BF),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF2B2B2D),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFFCACACA)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF))),
    scaffoldBackgroundColor: const Color(0xFF2B2B2D),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF2B2B2D), //CARD COLOR
    ),
    cardTheme: const CardTheme(
      color: Color(0xFF2B2B2D),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF202022),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF2B2B2D),
    ),
    bottomAppBarColor: const Color(0xFF2B2B2D),
    bottomSheetTheme:
    const BottomSheetThemeData(modalBackgroundColor: Color(0xFF2B2B2D)));

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
