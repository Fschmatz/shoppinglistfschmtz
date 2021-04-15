import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFE2E2EF),
    accentColor: Colors.blueAccent,
    scaffoldBackgroundColor: Color(0xFFF1F1F9), //0xFFF9F9FF
    cardTheme: CardTheme(
      color: Color(0xFFF8F8FF), //0xFFF1F1F8
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFF8F8FF),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Color(0xFFE1E1E7),
    ),
    bottomAppBarColor: Color(0xFFCED6E2),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFCED6E2)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF383737),
    accentColor: Color(0xFF6B89BF),
    scaffoldBackgroundColor: Color(0xFF383737),
    cardTheme: CardTheme(
      color: Color(0xFF383737),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF383737),
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: Color(0xFF37373A),
    ),

    bottomAppBarColor: Color(0xFF191818),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFF242424)));

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
