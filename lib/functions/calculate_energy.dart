import 'package:caloric/databases/day_entry.dart';

int calculateEnergy(List<DayEntry> data) {
  return data.fold(0, (sum, entry) => sum + entry.totalKcal);
}
