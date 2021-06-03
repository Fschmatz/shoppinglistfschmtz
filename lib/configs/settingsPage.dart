import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/util/theme.dart';
import '../util/changelog.dart';
import 'package:provider/provider.dart';
import 'appInfoPage.dart';
import 'changelogPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();

  SettingsPage({Key key}) : super(key: key);
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  Color themeColorApp = Color(0xFFFF5C78);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 1,
                margin: const EdgeInsets.fromLTRB(16, 20, 16, 25),
                color: themeColorApp,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: ListTile(
                  title: Text(
                    Changelog.appName + " " + Changelog.appVersion,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.5, color: Colors.black),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: SizedBox(
                  height: 0.1,
                ),
                title: Text("About".toUpperCase(),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: themeColorApp)),
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                ),
                title: Text(
                  "App Info",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AppInfoPage(),
                        fullscreenDialog: true,
                      ));
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              ListTile(
                leading: Icon(
                  Icons.text_snippet_outlined,
                ),
                title: Text(
                  "Changelog",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => ChangelogPage(),
                        fullscreenDialog: true,
                      ));
                },
              ),
              const Divider(),
              ListTile(
                leading: SizedBox(
                  height: 0.1,
                ),
                title: Text("General".toUpperCase(),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: themeColorApp)),
              ),
              Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => SwitchListTile(
                    title: Text(
                      "Dark Theme",
                      style: TextStyle(fontSize: 16),
                    ),
                    secondary: Icon(Icons.brightness_6_outlined),
                    activeColor: Colors.blue,
                    value: notifier.darkTheme,
                    onChanged: (value) {
                      notifier.toggleTheme();
                    }),
              ),
              const SizedBox(
                height: 10.0,
              ),
              FutureBuilder(
                  future: ShowCount()._loadFromPrefs(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SwitchListTile(
                          title: Text(
                            "Show Shoplist Item Count",
                            style: TextStyle(fontSize: 16),
                          ),
                          secondary: Icon(Icons.format_list_numbered_rtl),
                          activeColor: Colors.blue,
                          value: snapshot.data,
                          onChanged: (value) {
                            setState(() {
                              ShowCount().toggleShowCount(value);
                            });
                          });
                    }
                    return SizedBox.shrink();
                  })
            ],
          ),
        ));
  }
}

class ShowCount {
  final String key = 'showItemCount';
  SharedPreferences prefs;
  bool _showItemCount;

  _initPrefs() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  toggleShowCount(bool value) {
    _showItemCount = value;
    _saveToPrefs();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    return prefs.getBool(key) ?? true;
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(key, _showItemCount);
  }
}
