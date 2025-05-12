import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/energy_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:caloric/widgets/generic_breakdown.dart';
import '../functions/dates.dart';

class PastBreakdown extends StatelessWidget {
  const PastBreakdown({super.key, required this.settings, required this.date});

  final Settings settings;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.colorScheme.surface));
    List<dynamic> data = []; // TODO: Get data from given date via db
    int energyConsumed = 0; // TODO: Calculate energy consumed from db data

    return Column(
      children: [
        Container(
          color: theme.primaryColor,
          child: Column(
            children: [
              const SizedBox(height: 10, width: double.infinity),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: CalorieRing(
                    size: 140,
                    target: settings.energy.value,
                    type: settings.energy.unit,
                    energyConsumed: 0),
              ),
            ],
          ),
        ),
        GenericBreakdown(dateDisplay: displayDate(date), data: data)
      ],
    );
  }
}
