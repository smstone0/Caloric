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
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Container(
                color: theme.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: EnergyRing(
                    size: 100,
                    target: settings.energy.value,
                    type: settings.energy.unit,
                    energyConsumed: 0,
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
              date: getDate(date),
              data: data,
              topRadius: 0,
              topPadding: 0),
        ),
      ],
    );
  }
}
