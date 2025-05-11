import 'package:flutter/material.dart';
import 'databases/settings.dart';
import 'pages/today.dart';
import 'pages/settings.dart';
import 'pages/past.dart';
import 'pages/nutrition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode? themeMode;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    Settings settings = await SettingsDatabase().getSettings();
    ThemeMode storedMode = settings.appearance.theme;
    setState(() {
      themeMode = storedMode;
    });
  }

  void changeTheme(ThemeMode theme) {
    setState(() {
      themeMode = theme;
    });
  }

  ThemeMode? getThemeMode() {
    return themeMode;
  }

  ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: const Color.fromRGBO(235, 221, 255, 1),
    cardColor: const Color.fromRGBO(235, 221, 255, 0.5),
    colorScheme: const ColorScheme.light(),
  );

  ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: const Color.fromRGBO(235, 221, 255, 1),
    cardColor: const Color.fromRGBO(235, 221, 255, 0.5),
    colorScheme: const ColorScheme.dark(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caloric',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  void changeSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = TodayPage(
          callback: () {
            changeSelectedIndex(3);
          },
        );
        break;
      case 1:
        page = const PastPage();
        break;
      case 2:
        page = const NutritionPage();
        break;
      case 3:
        page = const SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        indicatorColor: Theme.of(context).primaryColor.withGreen(200),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Today'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Past'),
          NavigationDestination(icon: Icon(Icons.fastfood), label: 'Items'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
