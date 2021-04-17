import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFF1F1F1),
    accentColor: Colors.blueAccent,
    scaffoldBackgroundColor: Color(0xFFF1F1F1),
    cardTheme: CardTheme(
      color: Color(0xFFFFFFFF),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFF8F8FF),
    ),
    bottomAppBarColor: Color(0xFFBBBBBD),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFCED6E2)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF292929),
    accentColor: Color(0xFF6B89BF),
    scaffoldBackgroundColor: Color(0xFF292929),
    cardTheme: CardTheme(
      color: Color(0xFF393939),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF393939),
    ),
    bottomAppBarColor: Color(0xFF181818),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFF292929)));

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
