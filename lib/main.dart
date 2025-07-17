import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/db/criador_db.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:shoppinglistfschmtz/redux/actions.dart';
import 'package:shoppinglistfschmtz/redux/app_state.dart';
import 'app_theme.dart';

final Store<AppState> store = Store<AppState>(
  initialState: AppState.initialState(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = CriadorDb.instance;
  dbHelper.initDatabase();

  await store.dispatch(LoadShopListsAction());

  runApp(
    StoreProvider<AppState>(
      store: store,
      child: EasyDynamicThemeWidget(
        child: AppTheme(),
      ),
    ),
  );
}
