import 'package:caloric/main.dart';
import 'package:caloric/widgets/custom_button.dart';
import 'package:caloric/widgets/grey_card.dart';
import 'package:caloric/widgets/section_separator.dart';
import 'package:flutter/material.dart';
import 'package:caloric/widgets/heading.dart';
import 'package:flutter/services.dart';
import 'package:caloric/databases/nutrition_database.dart';

enum DropType { filter, sort }

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.background));
    return FutureBuilder<List<Nutrition>>(
        future: NutritionDatabase().getNutrition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Nutrition> nutrition = snapshot.data!;
            return ListView(
              children: const [
                Heading(text: "Nutrition"),
                RefineSearch(),
                SectionSeparator(),
              ],
            );
          }
        });
  }
}

class RefineSearch extends StatelessWidget {
  const RefineSearch({super.key});

  addNutrition() {}

  @override
  Widget build(BuildContext context) {
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
    TextStyle style = DefaultTextStyle.of(context).style;
    return GreyCard(
        child: Wrap(
      children: [
        NutritionDropdown(
            type: DropType.filter, list: filterList, display: 'Filter by'),
        NutritionDropdown(
            type: DropType.sort, list: sortList, display: 'Sort by'),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
          child: CustomButton(
              text: '+',
              onPressed: () {
                addNutrition();
              },
              colour: const Color.fromRGBO(205, 255, 182, 1),
              height: 46,
              width: 60),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
          child: SizedBox(
            width: 250,
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
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45.0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              onSubmitted: (value) {},
            ),
          ),
        ),
      ],
    ));
  }
}

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
      color: Theme.of(context).colorScheme.background,
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
