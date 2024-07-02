import 'package:flutter/material.dart';
import '../databases/nutrition.dart';
import '../databases/settings.dart';
import '../pages/nutrition_input.dart';
import 'grey_card.dart';

class NutCard extends StatelessWidget {
  const NutCard({super.key, required this.nutrition, required this.settings});

  final Nutrition nutrition;
  final Settings settings;

  @override
  Widget build(BuildContext context) {
    String energy;
    if (settings.energy.unit == EnergyUnit.calories) {
      energy = 'kcal';
    } else {
      energy = 'kJ';
    }
    return GreyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nutrition.item,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NutritionInput(
                            settings: settings,
                            nutrition: nutrition,
                            id: nutrition.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          Text(nutrition.type.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Added on ${nutrition.creationDate}"),
              Column(
                children: [
                  //TODO: Optional add/remove to day button
                  Text(
                      "${nutrition.energy}$energy per ${nutrition.quantity}${nutrition.unit}"),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
