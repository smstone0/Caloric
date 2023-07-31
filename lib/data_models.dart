class Settings {
  final double calorieGoal;
  final double height;
  final double weight;
  final String unit;
  final String mode;
  final DateTime time;

  const Settings(
      {required this.calorieGoal,
      required this.height,
      required this.weight,
      required this.unit,
      required this.mode,
      required this.time});

  Map<String, dynamic> settingsToMap() {
    return {
      'calorieGoal': calorieGoal,
      'height': height,
      'weight': weight,
      'unit': unit,
      'mode': mode,
      'time': time,
    };
  }
}
