import 'package:caloric/databases/day_entry.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/energy_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:caloric/widgets/generic_breakdown.dart';
import '../functions/dates.dart';
import '../functions/calculate_energy.dart';

class PastBreakdown extends StatelessWidget {
  const PastBreakdown({super.key, required this.settings, required this.date});

  //TODO: Store db data and energy as a state variable to avoid multiple db calls
  //TODO: Update on addition to day and update energy count on deletion

  final Settings settings;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.colorScheme.surface));
    String stringDate = getStringDate(date);

    return FutureBuilder<List<DayEntry>>(
        future: DayEntryDatabase().getDayEntriesForDate(stringDate),
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
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Container(
                        color: theme.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: EnergyRing(
                            size: 100,
                            target: settings.energy.value,
                            type: settings.energy.unit,
                            energyConsumed: totalEnergy,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: GenericBreakdown(
                      dateDisplay: displayDate(date),
                      date: getStringDate(date),
                      data: data,
                      topRadius: 0,
                      topPadding: 0),
                ),
              ],
            );
          }
        });
  }
}
