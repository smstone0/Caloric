import 'package:caloric/widgets/generic_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/energy_ring.dart';
import '../databases/settings.dart';
import '../functions/datetime.dart';
import '../functions/current_date.dart';

class TodayBreakdown extends StatelessWidget {
  const TodayBreakdown({super.key, required this.settings});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.primaryColor));
    DateTime time = DateTime.now();
    String currentDate = getCurrentDate();
    Color textColour = theme.primaryColor.computeLuminance() >= 0.5
        ? Colors.black
        : Colors.white;

    // TODO: Get today db data with currentDate

    return Column(
      children: [
        Container(
          color: theme.primaryColor,
          child: Column(
            children: [
              const SizedBox(height: 10, width: double.infinity),
              Text("Good ${getTimeOfDay()}!",
                  style:
                      theme.textTheme.titleLarge!.copyWith(color: textColour)),
              Text("Today is ${time.day} ${getMonth()}",
                  style:
                      theme.textTheme.bodyLarge!.copyWith(color: textColour)),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: CalorieRing(
                    size: 140,
                    target: settings.energy.value,
                    type: settings.energy.unit,
                    energyConsumed: 0), //TODO: Call calculate function passing in db data
              ),
            ],
          ),
        ),
        DayBreakdown(dateDisplay: "Today's Nutrition")
      ],
    );
  }
}
