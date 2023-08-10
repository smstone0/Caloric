import 'package:flutter/material.dart';
import '../widgets/calorie_ring.dart';
import '../widgets/grey_card.dart';
import '../databases/settings_database.dart';
import 'dart:math';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    String timeOfDay;
    String month;

    DateTime time = DateTime.parse(DateTime.now().toString());

    if (time.hour >= 0 && time.hour < 12) {
      timeOfDay = "morning";
    } else if (time.hour >= 12 && time.hour < 17) {
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
            return ListView(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: Column(
                      children: [
                        Text("Good $timeOfDay!",
                            style: const TextStyle(fontSize: 18)),
                        Text("Today is ${time.day} $month"),
                        const SizedBox(height: 20),
                        CalorieRing(size: 140, target: settings.calorieGoal),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const GreyCard(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 15),
                        child: ButtonCard(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GreyCard(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 15),
                        child: StatsCard(callback: callback, stats: settings),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        });
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({super.key, required this.callback, required this.stats});

  final VoidCallback callback;
  final Settings stats;

  @override
  Widget build(BuildContext context) {
    Color colour;
    String weightUnit, heightUnit;
    double weight, height;
    double bmi = stats.weight.metric / pow(stats.height.metric / 100, 2);

    if (stats.unit == Unit.metric) {
      weightUnit = 'kg';
      heightUnit = 'cm';
      weight = stats.weight.metric;
      height = stats.height.metric;
    } else {
      weightUnit = 'lbs';
      heightUnit = ' inches';
      weight = stats.weight.imperial;
      height = stats.height.imperial;
    }

    switch (bmi) {
      case < 18.5:
        colour = Colors.blue;
        break;
      case < 25:
        colour = Colors.green;
        break;
      case < 30:
        colour = Colors.orange;
        break;
      default:
        colour = Colors.red;
    }

    return Column(
      children: [
        const Text("Your weight is", style: TextStyle(fontSize: 16.5)),
        const SizedBox(height: 5),
        Card(
          elevation: 0,
          child: SizedBox(
            width: 100,
            height: 35,
            child: Center(
                child: Text("${weight.round()}$weightUnit",
                    style: const TextStyle(fontSize: 16.5))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text:
                            "For a height of ${height.round()}$heightUnit, this means your BMI is ",
                        style: const TextStyle(fontSize: 16.5)),
                    TextSpan(
                        text: bmi.toStringAsFixed(1),
                        style: TextStyle(color: colour, fontSize: 16.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        CustomButton(
            text: "Update weight/height",
            onPressed: () {
              callback();
            },
            colour: const Color.fromRGBO(217, 210, 226, 10),
            height: 38,
            width: 190),
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
    final List<Widget> buttons = [
      CustomButton(
        text: "Add",
        onPressed: () {
          print("Placeholder 1");
        },
        colour: const Color.fromRGBO(205, 255, 182, 1),
        height: 50,
        width: 105,
      ),
      CustomButton(
        text: "View",
        onPressed: () {
          print("Placeholder 2");
        },
        colour: const Color.fromRGBO(255, 212, 161, 1),
        height: 50,
        width: 105,
      ),
      CustomButton(
        text: "Remove",
        onPressed: () {
          print("Placeholder 3");
        },
        colour: const Color.fromRGBO(229, 139, 139, 1),
        height: 50,
        width: 105,
      ),
    ];

    return Column(
      children: [
        const Text("Nutrition for today", style: TextStyle(fontSize: 16.5)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: buttons,
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
      required this.colour,
      required this.height,
      required this.width});

  final String text;
  final VoidCallback onPressed;
  final Color colour;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
