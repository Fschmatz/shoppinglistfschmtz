import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/util/theme.dart';
import 'package:shoppinglistfschmtz/db/criador_db.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelperCriadorDB = CriadorDb.instance;
  dbHelperCriadorDB.initDatabase();

  runApp(
    EasyDynamicThemeWidget(
      child: const StartAppTheme(),
    ),
  );

}


class StartAppTheme extends StatelessWidget {
  const StartAppTheme({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: const App(),
    );
  }
}
