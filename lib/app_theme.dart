import 'package:flutter/material.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'app.dart';
import 'package:dynamic_color/dynamic_color.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightDynamic,
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.white,
              color: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic,
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF171717),
            appBarTheme: const AppBarTheme(
              surfaceTintColor: Color(0xFF171717),
              color: Color(0xFF171717),
            ),
          ),
          themeMode: EasyDynamicTheme.of(context).themeMode,
          home: App());
    });
  }
}
