import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caloric',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const TodayPage();
        break;
      case 1:
        page = Placeholder();
        break;
      case 2:
        page = Placeholder();
        break;
      case 3:
        page = Placeholder();
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
              color: Colors.white,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    String timeOfDay;
    String month;

    DateTime time = DateTime.parse(DateTime.now().toString());

    if (time.hour > 0 && time.hour < 12) {
      timeOfDay = "morning";
    } else if (time.hour > 12 && time.hour < 17) {
      timeOfDay = "afternoon";
    } else {
      timeOfDay = "evening";
    }

    switch (time.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      default:
        month = "December";
    }

    return Center(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: SafeArea(
                  child: Column(
                    children: [
                      Text("Good $timeOfDay!"),
                      Text("Today is ${time.day} $month"),
                      const SizedBox(height: 10),
                      Text("Placeholder"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                GreyCard(
                  child: ButtonCard(),
                ),
                SizedBox(height: 20),
                GreyCard(
                  child: StatsCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Your weight is"),
      ],
    );
  }
}

class ButtonCard extends StatelessWidget {
  const ButtonCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Nutrition for today"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Add",
              onPressed: () {
                print("Placeholder 1");
              },
              colour: const Color.fromRGBO(205, 255, 182, 1),
            ),
            CustomButton(
              text: "View",
              onPressed: () {
                print("Placeholder 2");
              },
              colour: const Color.fromRGBO(255, 212, 161, 1),
            ),
            CustomButton(
              text: "Remove",
              onPressed: () {
                print("Placeholder 3");
              },
              colour: const Color.fromRGBO(229, 139, 139, 1),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.colour});

  final String text;
  final VoidCallback onPressed;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: SizedBox(
        height: 50,
        width: 100,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colour,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(text,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal)),
        ),
      ),
    );
  }
}

class GreyCard extends StatelessWidget {
  const GreyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color.fromRGBO(217, 217, 217, 175),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: child,
        ),
      ),
    );
  }
}
