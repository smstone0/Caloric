import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Height {
  String toFeetAndInches(double totalInches) {
    double inches = totalInches % 12;
    double feet = (totalInches - inches) / 12;

    return "${feet.round()}'${inches.round()}\"";
  }

  double metric;
  double get imperial => metric / 2.54;
  set imperial(double imperial) {
    metric = imperial * 2.54;
  }

  String get feetandInches => toFeetAndInches(imperial);

  Height({required this.metric});
}

class Weight {
  double metric;
  double get imperial => metric * 2.205;
  set imperial(double imperial) {
    metric = imperial / 2.205;
  }

  Weight({required this.metric});
}

enum Unit { metric, imperial }

enum Appearance { system, light, dark }

class Settings {
  final int id;
  double calorieGoal;
  late Height height;
  late Weight weight;
  Unit unit;
  Appearance appearance;

  Settings(
      {required this.id,
      required this.calorieGoal,
      required double height,
      required double weight,
      required this.unit,
      required this.appearance}) {
    this.height = Height(metric: height);
    this.weight = Weight(metric: weight);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calorieGoal': calorieGoal,
      'height': height.metric,
      'weight': weight.metric,
      'unit': unit.index,
      'appearance': appearance.index,
    };
  }
}

class SettingsDatabase {
  Future<Database> openDatabaseConnection() async {
    return openDatabase(
      join(await getDatabasesPath(), 'settings_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE settings(id INTEGER PRIMARY KEY, calorieGoal FLOAT, height FLOAT, weight FLOAT, unit INT, appearance INT)',
        );
        await db.insert('settings', {
          'calorieGoal': 2000.0,
          'height': 170.0,
          'weight': 60.0,
          'unit': Unit.metric.index,
          'appearance': Appearance.system.index,
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
    );
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
