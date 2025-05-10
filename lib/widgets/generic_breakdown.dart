import 'package:flutter/material.dart';
import 'package:caloric/widgets/generic_card.dart';

class GenericBreakdown extends StatelessWidget {
  const GenericBreakdown(
      {super.key, required this.dateDisplay, required this.data});

  final String dateDisplay;
  final List<dynamic> data;

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
                  IconButton(
                      icon: Icon(
                        Icons.sort,
                        size: 18,
                      ),
                      onPressed: () {}),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 18),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 18),
                    onPressed: () {},
                  ),
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
