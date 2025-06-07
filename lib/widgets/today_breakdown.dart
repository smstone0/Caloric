import 'package:caloric/databases/settings.dart';
import 'package:caloric/functions/calculate_energy.dart';
import 'package:caloric/widgets/generic_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/energy_ring.dart';
import '../functions/dates.dart';
import '../databases/day_entry.dart';

class TodayBreakdown extends StatefulWidget {
  const TodayBreakdown({super.key, required this.settings});

  final Settings settings;

  @override
  State<TodayBreakdown> createState() => _TodayBreakdownState();
}

class _TodayBreakdownState extends State<TodayBreakdown> {
  @override
  void initState() {
    super.initState();
    _currentDate = getStringCurrentDate();
    _dayEntries = DayEntryDatabase().getDayEntriesForDate(_currentDate);
  }

  late Future<List<DayEntry>> _dayEntries;
  late String _currentDate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.primaryColor));
    DateTime time = DateTime.now();
    Color textColour = theme.primaryColor.computeLuminance() >= 0.5
        ? Colors.black
        : Colors.white;


        //TODO: Update future builder to have more consistent loading UI with loaded

    return FutureBuilder<List<DayEntry>>(
        future: _dayEntries,
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
                            target: widget.settings.energy.value,
                            type: widget.settings.energy.unit,
                            energyConsumed: totalEnergy),
                      ),
                    ],
                  ),
                ),
                GenericBreakdown(
                  dateDisplay: "Today's Nutrition",
                  data: data,
                  date: _currentDate,
                  refetchData: () {
                    setState(() {
                      _dayEntries =
                          DayEntryDatabase().getDayEntriesForDate(_currentDate);
                    });
                  },
                ),
              ],
            );
          }
        });
  }
}
