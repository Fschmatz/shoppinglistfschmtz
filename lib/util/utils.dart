import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_details.dart';

class Utils {
  void openGithubRepository() {
    launchBrowser(AppDetails.repositoryLink);
  }

  void launchBrowser(String url) {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  String getThemeStringFormatted(ThemeMode? currentTheme) {
    String theme = currentTheme.toString().replaceAll('ThemeMode.', '');
    if (theme == 'system') {
      theme = 'system default';
    }
    return theme.replaceFirst(theme[0], theme[0].toUpperCase());
  }

  String parseColorStringFromPicker(Color selectedColor) {
    int a = (selectedColor.a * 255.0).round() & 0xFF;
    int r = (selectedColor.r * 255.0).round() & 0xFF;
    int g = (selectedColor.g * 255.0).round() & 0xFF;
    int b = (selectedColor.b * 255.0).round() & 0xFF;

    return '0x${a.toRadixString(16).padLeft(2, '0')}${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }
}
