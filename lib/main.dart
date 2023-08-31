import 'package:caloric/databases/settings_database.dart';
import 'package:flutter/material.dart';
import 'pages/today_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode themeMode;

  @override
  void initState() {
    super.initState();
    _initializeThemeMode();
  }

  Future<void> _initializeThemeMode() async {
    Settings settings = await SettingsDatabase().getSettings();
    setState(() {
      themeMode = getAppearance(settings);
    });
  }

  ThemeMode getAppearance(Settings settings) {
    switch (settings.appearance) {
      case Appearance.system:
        return ThemeMode.system;
      case Appearance.light:
        return ThemeMode.light;
      case Appearance.dark:
        return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(themeMode);
    while (themeMode == null) {
      print("fuck you");
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
    return FutureBuilder<Settings>(
      future: SettingsDatabase().getSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primaryContainer),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Settings settings = snapshot.data!;
          //
          themeMode = getAppearance(settings);
          //
          return MaterialApp(
            title: 'Caloric',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: const MyHomePage(),
          );
        }
      },
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
        page = Placeholder();
        break;
      case 2:
        page = Placeholder();
        break;
      case 3:
        page = const SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.fastfood), label: 'Nutrition'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
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
              color: Theme.of(context).colorScheme.background,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
