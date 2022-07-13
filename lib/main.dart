import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/db/criador_db.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelperCriadorDB = CriadorDb.instance;
  dbHelperCriadorDB.initDatabase();

  runApp(
    EasyDynamicThemeWidget(
      child: const AppTheme(),
    ),
  );
}

