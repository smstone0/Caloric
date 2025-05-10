import 'package:flutter/material.dart';
import 'package:caloric/widgets/generic_card.dart';

enum Sort { oldToNew, newToOld, lowToHigh, highToLow, aToZ, zToA }

class GenericBreakdown extends StatefulWidget {
  const GenericBreakdown(
      {super.key, required this.dateDisplay, required this.data});

  final String dateDisplay;
  final List<dynamic> data;

  @override
  State<GenericBreakdown> createState() => _GenericBreakdownState();
}

class _GenericBreakdownState extends State<GenericBreakdown> {
  bool _removeSelected = false;

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
                false == true
                    ? Text("Nothing to show yet!",
                        style: theme.textTheme.bodyLarge!.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.5)))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //TODO: Loop through db data with builder
                          Text("Breakfast", style: theme.textTheme.bodyLarge),
                          Row(
                            children: [
                              Text("Calories",
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
