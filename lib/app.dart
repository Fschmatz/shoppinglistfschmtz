import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/pages/home/home.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Colors.transparent,
        ),
        child: const Home()
    );
  }
}
