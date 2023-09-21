import 'package:caloric/databases/nutrition_database.dart';
import 'package:caloric/databases/settings_database.dart';
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

class InputCard extends StatelessWidget {
  const InputCard({super.key, required this.settings});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    Nutrition newNutrition;
    String energy;
    if (settings.energy.unit == EnergyUnit.calories) {
      energy = 'kcal';
    } else {
      energy = 'kJ';
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Add item",
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
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
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ButtonRow(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [Text("x $energy per (quantity)(unit)")],
            ),
          )
        ],
      ),
    );
  }
}

class ButtonRow extends StatefulWidget {
  const ButtonRow({
    super.key,
  });

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  late NutType type;
  bool foodClick = false;
  bool drinkClick = false;

  Color clickColour(bool click) {
    if (click) {
      return Theme.of(context).primaryColor;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    Color foodColour = clickColour(foodClick);
    Color drinkColour = clickColour(drinkClick);
    return Row(
      children: [
        CustomButton(
            widget: const Text("Food"),
            onPressed: () {
              setState(() {
                foodClick = true;
                drinkClick = false;
                type = NutType.food;
              });
            },
            colour: foodColour,
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
              });
            },
            colour: drinkColour,
            height: 40,
            width: 85)
      ],
    );
  }
}
