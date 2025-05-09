import 'package:flutter/material.dart';
import 'package:caloric/widgets/generic_card.dart';

class DayBreakdown extends StatelessWidget {
  const DayBreakdown({super.key, required this.dateDisplay, this.data});

  final String dateDisplay;
  final List<dynamic>? data; //TODO: Change to correct type

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GenericCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(dateDisplay, style: theme.textTheme.titleMedium),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.sort,
                    size: 18,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.remove, size: 18),
                  const SizedBox(width: 5),
                  Icon(Icons.add, size: 18),
                ],
              ),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                true == true
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
