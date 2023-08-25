import 'package:caloric/databases/settings_database.dart';
import 'package:flutter/material.dart';
import 'pages/today_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData getAppearance(Settings settings, Brightness systemBrightness) {
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

  @override
  Widget build(BuildContext context) {
    Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
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
          return MaterialApp(
            title: 'Caloric',
            theme: getAppearance(settings, systemBrightness),
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
