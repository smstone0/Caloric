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
    final ThemeData theme = Theme.of(context);
    final unitLabel =
        settings.energy.unit == EnergyUnit.calories ? 'kcal' : 'kJ';

    return GenericCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.itemName,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (item.kcalPer100Unit != null && item.kcalPer100Unit! > 0)
                    Text(
                      "${item.kcalPer100Unit}$unitLabel per 100${item.unit?.name}",
                      style: theme.textTheme.bodyLarge,
                    ),
                  if (item.customUnitName != null &&
                      item.customUnitName!.isNotEmpty)
                    Text(
                      "${item.kcalPerCustomUnit}$unitLabel per ${item.customUnitName}",
                      style: theme.textTheme.bodyLarge,
                    ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
