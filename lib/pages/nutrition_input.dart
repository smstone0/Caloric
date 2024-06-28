import 'package:caloric/databases/nutrition.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/custom_button.dart';
import 'package:caloric/widgets/grey_card.dart';
import 'package:flutter/material.dart';

class AddNutritionPage extends StatelessWidget {
  const AddNutritionPage({super.key, required this.settings});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListView(
      children: [
        const SizedBox(height: 20),
        GreyCard(
          child: InputCard(settings: settings),
        ),
      ],
    ));
  }
}

class InputCard extends StatefulWidget {
  const InputCard({super.key, required this.settings});

  final Settings settings;

  @override
  State<InputCard> createState() => _InputCardState();
}

class _InputCardState extends State<InputCard> {
  bool foodClick = false;
  bool drinkClick = false;
  late NutType type;
  String unit = "";

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add item", style: theme.textTheme.titleMedium),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, right: 50),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                filled: true,
                hintText: "Enter name of item",
                hintStyle: DefaultTextStyle.of(context).style,
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 4,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              onSubmitted: (value) {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                CustomButton(
                    widget: const Text("Food"),
                    onPressed: () {
                      setState(() {
                        foodClick = true;
                        drinkClick = false;
                        type = NutType.food;
                        unit = 'g';
                      });
                    },
                    colour: foodClick == true
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    height: 40,
                    width: 85),
                const SizedBox(width: 5),
                CustomButton(
                    widget: const Text("Drink"),
                    onPressed: () {
                      setState(() {
                        drinkClick = true;
                        foodClick = false;
                        type = NutType.drink;
                        unit = 'ml';
                      });
                    },
                    colour: drinkClick == true
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    height: 40,
                    width: 85)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                //Energy
                SizedBox(
                  width: 90,
                  height: 30,
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      suffixIcon: Text(
                          widget.settings.energy.unit == EnergyUnit.calories
                              ? 'kcal'
                              : 'kJ'),
                      suffixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 4,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    onSubmitted: (value) {},
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Text("per "),
              //Quantity
              SizedBox(
                width: 195,
                height: 30,
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,
                    //Unit
                    suffixIcon: Text(unit),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 4,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  onSubmitted: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
