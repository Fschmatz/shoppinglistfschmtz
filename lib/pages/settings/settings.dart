import 'package:flutter/material.dart';
import '../../util/app_details.dart';
import '../../util/dialog_select_theme.dart';
import '../../util/utils.dart';
import 'app_info.dart';
import 'changelog.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();

  const Settings({super.key});
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    Color themeColorApp = Theme.of(context).colorScheme.tertiary;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 25),
              color: themeColorApp,
              child: ListTile(
                title: Text(
                  "${AppDetails.appName} ${AppDetails.appVersion}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17.5, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: Text("General", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorApp)),
            ),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogSelectTheme();
                  }),
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text(
                "App theme",
              ),
              subtitle: Text(
                Utils().getThemeStringFormatted(EasyDynamicTheme.of(context).themeMode),
              ),
            ),
            ListTile(
              title: Text("About", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorApp)),
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),
              title: const Text(
                "App info",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AppInfo(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.text_snippet_outlined,
              ),
              title: const Text(
                "Changelog",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Changelog(),
                    ));
              },
            ),
          ],
        ));
  }
}
