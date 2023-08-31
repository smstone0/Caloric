import 'package:flutter/material.dart';
import 'databases/settings_database.dart';

ThemeData getAppearance(Brightness systemBrightness, Settings settings) {
  ThemeData light = ThemeData(
    useMaterial3: true,
    primaryColor: const Color.fromRGBO(235, 221, 255, 1),
    cardColor: const Color.fromRGBO(235, 221, 255, 0.5),
    colorScheme: const ColorScheme.light(),
  );
  ThemeData dark = ThemeData(
    useMaterial3: true,
    primaryColor: const Color.fromRGBO(235, 221, 255, 1),
    cardColor: const Color.fromRGBO(235, 221, 255, 0.5),
    colorScheme: const ColorScheme.dark(),
  );
  String appearance = settings.appearance.name;
  if (settings.appearance == Appearance.system) {
    systemBrightness == Brightness.light
        ? appearance = 'light'
        : appearance = 'dark';
  }
  switch (appearance) {
    case 'light':
      return light;
    default:
      return dark;
  }
}

class ThemeProvider extends ChangeNotifier {
  final BuildContext context;

  ThemeProvider(this.context) {
    initialiseSettings();
  }

  late Settings settings;
  Brightness get systemBrightness => MediaQuery.of(context).platformBrightness;
  ThemeData get appearance => getAppearance(systemBrightness, settings);

  Future<void> initialiseSettings() async {
    settings = await SettingsDatabase().getSettings();
    //notifyListeners();
  }

  setAppearance() {
    notifyListeners();
  }
}
