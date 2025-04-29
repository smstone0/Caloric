import 'package:flutter/material.dart';
import 'package:caloric/widgets/generic_card.dart';
import 'package:caloric/functions/current_date.dart';

class DayBreakdown extends StatelessWidget {
  const DayBreakdown({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    final String today = getCurrentDate();
    final ThemeData theme = Theme.of(context);
    final data = true; //TODO: Get data from database

    return GenericCard(
      child: Column(
        children: [
          Row(
            children: [
              Text(date == today ? 'Today\'s Nutrition' : date,
                  style: theme.textTheme.titleMedium),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                true == true //TODO: Check data exists
                    ? Text("Nothing to show yet!",
                        style: theme.textTheme.bodyLarge!.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.5)))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //TODO: Loop through data
                          Text("Breakfast", style: theme.textTheme.bodyLarge),
                          Text("Lunch", style: theme.textTheme.bodyLarge),
                          Text("Dinner", style: theme.textTheme.bodyLarge),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
