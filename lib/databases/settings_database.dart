import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Height {
  String feetAndInches() {
    double inch = inches % 12;
    double feet = (inches - inch) / 12;

    return "${feet.round()}'${inch.round()}\"";
  }

  double cm;
  double get inches => cm / 2.54;
  set inches(double inches) {
    cm = inches * 2.54;
  }

  double get m => cm / 100;
  set m(double m) {
    cm = m * 100;
  }

  String get feetandInches => feetAndInches();

  Height({required this.cm});
}

class Weight {
  String stonesAndPounds() {
    double pounds = lbs % 14;
    double stones = (lbs - pounds) / 14;
    return "${stones.round()}st ${pounds.round()}lbs";
  }

  double kg;
  double get lbs => kg * 2.205;
  set lbs(double lbs) {
    kg = lbs / 2.205;
  }

  String get stonesandPounds => stonesAndPounds();

  Weight({required this.kg});
}

enum Unit { metric, imperial }

enum MetricHeight { m, cm }

// MetricWeight = kg

enum ImperialHeight { ftinches, inches }

enum ImperialWeight { lbs, stonelbs }

enum Appearance { system, light, dark }

class Settings {
  final int id;
  double calorieGoal;
  late Height height;
  late Weight weight;
  Unit unit;
  Appearance appearance;
  MetricHeight metricHeight;
  ImperialHeight imperialHeight;
  ImperialWeight imperialWeight;

  Settings(
      {required this.id,
      required this.calorieGoal,
      required double height,
      required double weight,
      required this.unit,
      required this.appearance,
      required this.metricHeight,
      required this.imperialHeight,
      required this.imperialWeight}) {
    this.height = Height(cm: height);
    this.weight = Weight(kg: weight);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calorieGoal': calorieGoal,
      'height': height.cm,
      'weight': weight.kg,
      'unit': unit.index,
      'appearance': appearance.index,
      'metricHeight': metricHeight.index,
      'imperialHeight': imperialHeight.index,
      'imperialWeight': imperialWeight.index,
    };
  }
}

class SettingsDatabase {
  Future<Database> openDatabaseConnection() async {
    return openDatabase(
      join(await getDatabasesPath(), 'settings_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE settings(id INTEGER PRIMARY KEY, calorieGoal FLOAT, height FLOAT, weight FLOAT, unit INT, appearance INT, metricHeight INT, imperialHeight INT, imperialWeight INT)',
        );
        await db.insert('settings', {
          'calorieGoal': 2000.0,
          'height': 170.0,
          'weight': 60.0,
          'unit': Unit.metric.index,
          'appearance': Appearance.system.index,
          'metricHeight': MetricHeight.cm.index,
          'imperialHeight': ImperialHeight.ftinches.index,
          'imperialWeight': ImperialWeight.lbs.index,
        });
      },
      version: 1,
    );
  }

  Future<void> insertSettings(Settings settings) async {
    final db = await openDatabaseConnection();
    await db.insert(
      'settings',
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Settings> getSettings() async {
    final db = await openDatabaseConnection();
    final List<Map<String, dynamic>> maps = await db.query('settings');
    return Settings(
        id: maps[0]['id'],
        calorieGoal: maps[0]['calorieGoal'],
        height: maps[0]['height'],
        weight: maps[0]['weight'],
        unit: Unit.values[maps[0]['unit']],
        appearance: Appearance.values[maps[0]['appearance']],
        metricHeight: MetricHeight.values[maps[0]['metricHeight']],
        imperialHeight: ImperialHeight.values[maps[0]['imperialHeight']],
        imperialWeight: ImperialWeight.values[maps[0]['imperialWeight']]);
  }

  Future<void> updateSettings(Settings settings) async {
    final db = await openDatabaseConnection();
    await db.update(
      'settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }

  Future<void> deleteSettings(int id) async {
    final db = await openDatabaseConnection();
    await db.delete(
      'settings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
