import 'package:caloric/databases/day_entry.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/energy_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:caloric/widgets/generic_breakdown.dart';
import '../functions/dates.dart';
import '../functions/calculate_energy.dart';

class PastBreakdown extends StatefulWidget {
  const PastBreakdown({super.key, required this.settings, required this.date});

  final Settings settings;
  final DateTime date;

  @override
  State<PastBreakdown> createState() => _PastBreakdownState();
}

class _PastBreakdownState extends State<PastBreakdown> {
  @override
  void initState() {
    super.initState();
    _stringDate = getStringDate(widget.date);
    _dayEntries = DayEntryDatabase().getDayEntriesForDate(_stringDate);
  }

  late Future<List<DayEntry>> _dayEntries;
  late String _stringDate;

  //TODO: Update future builder to have more consistent loading UI with loaded

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.colorScheme.surface));

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
                            target: widget.settings.energy.value,
                            type: widget.settings.energy.unit,
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
                    dateDisplay: displayDate(widget.date),
                    date: _stringDate,
                    data: data,
                    topRadius: 0,
                    topPadding: 0,
                    refetchData: () => {
                      setState(() {
                        _dayEntries = DayEntryDatabase()
                            .getDayEntriesForDate(_stringDate);
                      })
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}
