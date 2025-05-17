import 'package:flutter/material.dart';
import '../databases/items.dart';
import '../databases/settings.dart';
import 'generic_card.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.settings});

  final Item item;
  final Settings settings;

  @override
  Widget build(BuildContext context) {
    String energy;
    if (settings.energy.unit == EnergyUnit.calories) {
      energy = 'kcal';
    } else {
      energy = 'kJ';
    }
    return GenericCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.itemName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text(
                      "${item.kcalPer100Unit}$energy per 100 ${item.unit?.name}"),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
