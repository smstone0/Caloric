import 'package:caloric/databases/items.dart';
import 'package:caloric/pages/items.dart';

int getKcal(Item item) => item.kcalPer100Unit ?? item.kcalPerCustomUnit ?? 0;

List<Item> getSortedItems(List<Item> items, Sort sort) {
  switch (sort) {
    case Sort.oldToNew:
      return items..sort((a, b) => b.dateSaved.compareTo(a.dateSaved));
    case Sort.newToOld:
      return items..sort((a, b) => a.dateSaved.compareTo(b.dateSaved));
    case Sort.lowToHigh:
      return items..sort((a, b) => getKcal(a).compareTo(getKcal(b)));
    case Sort.highToLow:
      return items..sort((a, b) => getKcal(b).compareTo(getKcal(a)));
    case Sort.aToZ:
      return items..sort((a, b) => a.itemName.compareTo(b.itemName));
    case Sort.zToA:
      return items..sort((a, b) => b.itemName.compareTo(a.itemName));
  }
}
