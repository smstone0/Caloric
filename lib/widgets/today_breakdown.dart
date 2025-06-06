import 'package:caloric/databases/settings.dart';
import 'package:caloric/functions/calculate_energy.dart';
import 'package:caloric/widgets/generic_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/energy_ring.dart';
import '../functions/dates.dart';
import '../databases/day_entry.dart';

class TodayBreakdown extends StatelessWidget {
  const TodayBreakdown({super.key, required this.settings});

  final Settings settings;

  //TODO: Store db data and energy as a state variable to avoid multiple db calls
  //TODO: Update on addition to day and update energy count on deletion

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.primaryColor));
    DateTime time = DateTime.now();
    String currentDate = getStringCurrentDate();
    Color textColour = theme.primaryColor.computeLuminance() >= 0.5
        ? Colors.black
        : Colors.white;

    return FutureBuilder<List<DayEntry>>(
        future: DayEntryDatabase().getDayEntriesForDate(currentDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<DayEntry> data = snapshot.data!;
            int totalEnergy = calculateEnergy(data);
            return Column(
              children: [
                Container(
                  color: theme.primaryColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 10, width: double.infinity),
                      Text("Good ${getTimeOfDay()}!",
                          style: theme.textTheme.titleLarge!
                              .copyWith(color: textColour)),
                      Text("Today is ${time.day} ${getMonth()}",
                          style: theme.textTheme.bodyLarge!
                              .copyWith(color: textColour)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: EnergyRing(
                            size: 140,
                            target: settings.energy.value,
                            type: settings.energy.unit,
                            energyConsumed: totalEnergy),
                      ),
                    ],
                  ),
                ),
                GenericBreakdown(
                    dateDisplay: "Today's Nutrition",
                    data: data,
                    date: currentDate)
              ],
            );
          }
        });
  }
}
