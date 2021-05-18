import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFF3F3F3),
    accentColor: Colors.blueAccent,
    scaffoldBackgroundColor: Color(0xFFF3F3F3),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xFFFFFFFF),
    ),
    cardTheme: CardTheme(
      color: Color(0xFFFFFFFF),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFF8F8F8),
    ),
    bottomAppBarColor: Color(0xFFDBDBDD),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFF3F3F3)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF202020),
    accentColor: Color(0xFF6B89BF),
    scaffoldBackgroundColor: Color(0xFF202020),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xFF353535), //CARD COLOR
    ),
    cardTheme: CardTheme(
      color: Color(0xFF353535),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF3B3B3B),
    ),
    bottomAppBarColor: Color(0xFF161616),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFF202020)));

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
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
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
