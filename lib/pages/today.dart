import 'package:caloric/widgets/today_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/generic_card.dart';
import '../databases/settings.dart';
import 'dart:math';
import '../widgets/custom_button.dart';
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
                TodayBreakdown(
                  settings: settings,
                ),
                GenericCard(
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            const TextSpan(text: 'Your weight is '),
                            TextSpan(
                                text: '${settings.weight}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(text: '\nFor a height of '),
                            TextSpan(
                                text: '${settings.height}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(text: ', this means your BMI is '),
                            TextSpan(
                                text: bmi.toStringAsFixed(1),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getColourBMI(bmi))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomButton(
                        widget: const Text("Update"),
                        onPressed: () {
                          callback();
                        },
                        colour: theme.cardColor.withOpacity(1),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        });
  }
}
