import 'package:caloric/databases/settings.dart';
import 'package:flutter/material.dart';
import 'package:caloric/widgets/generic_card.dart';
import 'package:caloric/pages/add_day_entry.dart';

enum Sort { oldToNew, newToOld, lowToHigh, highToLow, aToZ, zToA }

class GenericBreakdown extends StatefulWidget {
  const GenericBreakdown(
      {super.key,
      required this.dateDisplay,
      required this.date,
      required this.data,
      this.topRadius,
      this.topPadding});

  final String dateDisplay;
  final String date;
  final List<dynamic> data;
  final double? topRadius;
  final double? topPadding;

  @override
  State<GenericBreakdown> createState() => _GenericBreakdownState();
}

class _GenericBreakdownState extends State<GenericBreakdown> {
  bool _removeSelected = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GenericCard(
      topRadius: widget.topRadius,
      topPadding: widget.topPadding,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(widget.dateDisplay, style: theme.textTheme.titleMedium),
                  Stack(
                    children: [
                      //TODO: Add dropdown menu for sorting
                      IconButton(
                          icon: Icon(
                            Icons.sort,
                            size: 18,
                          ),
                          onPressed: () {}),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _removeSelected ? Color(0xFFE58B8B) : null,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.remove, size: 18),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        setState(() {
                          _removeSelected = !_removeSelected;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 18),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddDayEntry(
                              unit:
                                  EnergyUnit.calories, //TODO: Placeholder unit
                              displayDate: widget.dateDisplay,
                              date: widget.date),
                        ),
                      );
                    },
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
                widget.data.isEmpty
                    ? Text("Nothing to show yet!",
                        style: theme.textTheme.bodyLarge!.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.5)))
                    : Column(
                        children: [
                          ...widget.data.map(
                            (item) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${item.amount} ${item.recordedByUnit} ${item.itemName}",
                                    style: theme.textTheme.bodyLarge),
                                Row(
                                  children: [
                                    Text("${item.totalKcal} kcal",
                                        style: theme.textTheme.bodyLarge),
                                    Visibility(
                                      visible: _removeSelected,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: IconButton(
                                        icon: Icon(Icons.remove, size: 18),
                                        onPressed: () {},
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
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
