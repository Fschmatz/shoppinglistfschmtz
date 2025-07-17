import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

class DialogSelectTheme extends StatefulWidget {
  @override
  State<DialogSelectTheme> createState() => _DialogSelectThemeState();

  const DialogSelectTheme({super.key});
}

class _DialogSelectThemeState extends State<DialogSelectTheme> {
  final List<String> _themes = ['ThemeMode.light', 'ThemeMode.dark', 'ThemeMode.system'];

  @override
  Widget build(BuildContext context) {
    ThemeMode? currentTheme = EasyDynamicTheme.of(context).themeMode;
    Color appAccent = Theme.of(context).colorScheme.primary;

    return AlertDialog(
      title: const Text('Select Theme'),
      content: SizedBox(
          width: 350.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                activeColor: appAccent,
                key: UniqueKey(),
                value: 0,
                groupValue: currentTheme.toString() == _themes[0] ? 0 : null,
                title: const Text('Light'),
                onChanged: (v) => {EasyDynamicTheme.of(context).changeTheme(dark: false)},
              ),
              RadioListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                activeColor: appAccent,
                key: UniqueKey(),
                value: 1,
                groupValue: currentTheme.toString() == _themes[1] ? 1 : null,
                title: const Text('Dark'),
                onChanged: (v) => {EasyDynamicTheme.of(context).changeTheme(dark: true)},
              ),
              RadioListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                activeColor: appAccent,
                key: UniqueKey(),
                value: 2,
                groupValue: currentTheme.toString() == _themes[2] ? 2 : null,
                title: const Text('System default'),
                onChanged: (v) => {EasyDynamicTheme.of(context).changeTheme(dynamic: true)},
              ),
            ],
          )),
    );
  }
}
