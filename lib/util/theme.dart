import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFFFFFFF),
    accentColor: Colors.blueAccent,
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xFFFFFFFF),
    ),
    cardTheme: CardTheme(
      color: Color(0xFFFFFFFF),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFFFFFFF),
    ),
    bottomAppBarColor: Color(0xFFF4F4F4),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFF4F4F4)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF262626),
    accentColor: Color(0xFF6B89BF),
    scaffoldBackgroundColor: Color(0xFF262626),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xFF323232), //CARD COLOR
    ),
    cardTheme: CardTheme(
      color: Color(0xFF323232),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF262626),
    ),
    bottomAppBarColor: Color(0xFF202020),
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
