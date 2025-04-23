import 'package:caloric/main.dart';
import 'package:caloric/pages/nutrition_input.dart';
import 'package:caloric/widgets/generic_card.dart';
import 'package:caloric/widgets/section_separator.dart';
import 'package:flutter/material.dart';
import 'package:caloric/widgets/heading.dart';
import 'package:flutter/services.dart';
import 'package:caloric/databases/nutrition.dart';
import 'package:caloric/databases/settings.dart';

import '../widgets/nutrition_card.dart';

enum DropType { filter, sort }

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle style = DefaultTextStyle.of(context).style;

    List<String> filterList = [
      'Food',
      'Drink',
      'Less than x',
      'More than x',
    ];
    List<String> sortList = [
      'Oldest to newest',
      'Newest to oldest',
      'Low to high',
      'High to low',
      'A-Z',
      'Z-A'
    ];

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.colorScheme.surface));
    return FutureBuilder<List<Nutrition>>(
        future: NutritionDatabase().getNutrition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Nutrition> nutrition = snapshot.data!;
            return FutureBuilder<Settings>(
                future: SettingsDatabase().getSettings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:
                          CircularProgressIndicator(color: theme.primaryColor),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Settings settings = snapshot.data!;
                    return ListView(
                      children: [
                        const Heading(text: "Nutrition"),
                        GenericCard(
                            child: Wrap(
                          runSpacing: 5,
                          children: [
                            NutritionDropdown(
                                type: DropType.filter,
                                list: filterList,
                                display: 'Filter by'),
                            NutritionDropdown(
                                type: DropType.sort,
                                list: sortList,
                                display: 'Sort by'),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NutritionInput(
                                          settings: settings,
                                          id: nutrition.length),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                                color: settings.appearance ==
                                            Appearance.light ||
                                        settings.appearance ==
                                                Appearance.system &&
                                            MediaQuery.of(context)
                                                    .platformBrightness ==
                                                Brightness.light
                                    ? Colors.black
                                    : const Color.fromRGBO(205, 255, 182, 1)),
                            SizedBox(
                              height: 50,
                              child: TextField(
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "Search for item",
                                  hintStyle: style,
                                  prefixIcon: const Icon(Icons.search),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(45),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(45),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                                onSubmitted: (value) {},
                              ),
                            ),
                          ],
                        )),
                        const SectionSeparator(),
                        NutritionCards(
                            nutrition: nutrition, settings: settings),
                      ],
                    );
                  }
                });
          }
        });
  }
}

//TODO: Combine settings and nutrition dropdowns
class NutritionDropdown extends StatefulWidget {
  const NutritionDropdown(
      {super.key,
      required this.type,
      required this.list,
      required this.display});

  final DropType type;
  final String display;
  final List<String> list;

  @override
  State<NutritionDropdown> createState() => _NutritionDropdownState();
}

class _NutritionDropdownState extends State<NutritionDropdown> {
  @override
  Widget build(BuildContext context) {
    Color colour;
    Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    if (MyApp.of(context)!.getThemeMode() == ThemeMode.light ||
        (MyApp.of(context)!.getThemeMode() == ThemeMode.system &&
            systemBrightness == Brightness.light)) {
      colour = Colors.black;
    } else {
      colour = Colors.white;
    }

    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: SizedBox(
          width: 110,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              selectedItemBuilder: (BuildContext context) {
                return widget.list.map<Widget>((String item) {
                  return Center(
                    child: Text(
                      widget.display,
                      style: TextStyle(
                        color: colour,
                      ),
                    ),
                  );
                }).toList();
              },
              items: widget.list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle(
                            color: Theme.of(context)
                                        .primaryColor
                                        .computeLuminance() >=
                                    0.5
                                ? Colors.black
                                : Colors.white)));
              }).toList(),
              value: widget.list.first,
              style: DefaultTextStyle.of(context).style,
              dropdownColor: Theme.of(context).primaryColor,
              onChanged: (String? value) {
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NutritionCards extends StatelessWidget {
  const NutritionCards(
      {super.key, required this.nutrition, required this.settings});

  final List<Nutrition> nutrition;
  final Settings settings;

  @override
  Widget build(BuildContext context) {
    List<NutCard> cards = [];
    for (int i = 0; i < nutrition.length; i++) {
      cards.add(NutCard(nutrition: nutrition[i], settings: settings));
    }

    return Column(
      children: cards.isNotEmpty
          ? cards
          : [const Text("You have not yet added any items")],
    );
  }
}
