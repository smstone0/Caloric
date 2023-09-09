import 'package:flutter/material.dart';
import 'databases/settings_database.dart';
import 'pages/today_page.dart';
import 'pages/settings_page.dart';

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
  late ThemeMode themeMode;
  bool fetchData = true;

  void changeTheme(ThemeMode theme) {
    setState(() {
      themeMode = theme;
    });
  }

  ThemeMode getThemeMode() {
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
    if (fetchData == true) {
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
            themeMode = settings.appearance.theme;
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
    } else {
      return MaterialApp(
        title: 'Caloric',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: const MyHomePage(),
      );
    }
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
        indicatorColor: Theme.of(context).primaryColor.withGreen(200),
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
