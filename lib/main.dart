import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/pages/home/home.dart';
import 'package:shoppinglistfschmtz/util/theme.dart';
import 'package:provider/provider.dart';
import 'package:shoppinglistfschmtz/db/criadorDb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelperCriadorDB = criadorDb.instance;
  dbHelperCriadorDB.initDatabase();


  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),

    child: Consumer<ThemeNotifier>(
      builder:(context, ThemeNotifier notifier, child){

        return MaterialApp(
          theme: notifier.darkTheme ? dark : light,
          home: Home(),
        );
      },
    ),
  )
  );
}


