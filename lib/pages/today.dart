import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/energy_ring.dart';
import '../widgets/grey_card.dart';
import '../databases/settings.dart';
import 'dart:math';
import '../widgets/custom_button.dart';
import '../functions/datetime.dart';
import '../functions/bmi.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double bmi;

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
            bmi = settings.weight.kg / pow(settings.height.cm / 100, 2);
            return ListView(
              children: [
                Container(
                  color: theme.primaryColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text("Good ${getTimeOfDay()}!",
                          style: theme.textTheme.titleLarge!
                              .copyWith(color: textColour)),
                      Text("Today is ${time.day} ${getMonth()}",
                          style: theme.textTheme.bodyLarge!
                              .copyWith(color: textColour)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: CalorieRing(
                            size: 140,
                            target: settings.energy.value,
                            type: settings.energy.unit),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const GreyCard(
                      child: ButtonCard(),
                    ),
                    GreyCard(
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "With a weight of ${settings.weight} and a height of ${settings.height}, your BMI is ",
                                ),
                                TextSpan(
                                    text: bmi.toStringAsFixed(1),
                                    style: TextStyle(color: getColourBMI(bmi))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                              widget: const Text("Update weight/height"),
                              onPressed: () {
                                callback();
                              },
                              colour:
                                  Theme.of(context).cardColor.withOpacity(1),
                              height: 38,
                              width: 190),
                        ],
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
