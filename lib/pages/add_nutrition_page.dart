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
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Row(
              children: [
                Text("Name of item/untitled", style: TextStyle(fontSize: 15))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                CustomButton(
                    widget: const Text("Food"),
                    onPressed: () {},
                    colour: Theme.of(context).primaryColor,
                    height: 30,
                    width: 85),
                const SizedBox(width: 5),
                CustomButton(
                    widget: const Text("Drink"),
                    onPressed: () {},
                    colour: Theme.of(context).primaryColor,
                    height: 30,
                    width: 85)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
              children: [Text("x $energy per (quantity)(unit)")],
            ),
          )
        ],
      ),
    );
  }
}
