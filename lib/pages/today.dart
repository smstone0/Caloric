import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/energy_ring.dart';
import '../widgets/grey_card.dart';
import '../databases/settings.dart';
import 'dart:math';
import '../widgets/custom_button.dart';
import '../functions/datetime.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.primaryColor));
    DateTime time = DateTime.now();
    Color textColour = theme.primaryColor.computeLuminance() >= 0.5
        ? Colors.black
        : Colors.white;

    return FutureBuilder<Settings>(
        future: SettingsDatabase().getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Settings settings = snapshot.data!;
            return ListView(
              children: [
                Container(
                  color: theme.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: Column(
                      children: [
                        Text("Good ${getTimeOfDay()}!",
                            style: TextStyle(fontSize: 18, color: textColour)),
                        Text("Today is ${time.day} ${getMonth()}",
                            style: TextStyle(color: textColour)),
                        const SizedBox(height: 20),
                        CalorieRing(
                            size: 140,
                            target: settings.energy.value,
                            type: settings.energy.unit),
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
    String weight, height;
    double bmi = stats.weight.kg / pow(stats.height.cm / 100, 2);

    height = stats.height.toString();
    weight = stats.weight.toString();

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
                child: Text(weight, style: const TextStyle(fontSize: 16.5))),
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
                            "For a height of $height, this means your BMI is ",
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
            widget: const Text("Update weight/height"),
            onPressed: () {
              callback();
            },
            colour: Theme.of(context).cardColor.withOpacity(1),
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
        widget: const Text("Add"),
        onPressed: () {},
        colour: const Color.fromRGBO(205, 255, 182, 1),
        height: 50,
        width: 105,
      ),
      CustomButton(
        widget: const Text("View"),
        onPressed: () {},
        colour: const Color.fromRGBO(255, 212, 161, 1),
        height: 50,
        width: 105,
      ),
      CustomButton(
        widget: const Text("Remove"),
        onPressed: () {},
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
