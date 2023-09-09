import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum UnitSystem { metric, imperial }

enum HeightUnit { metres, centimetres, feet, inches }

enum WeightUnit { kg, lbs, stone }

enum EnergyUnit { calories, joules }

enum Appearance { system, light, dark }

extension ThemeSupport on Appearance {
  ThemeMode get theme {
    switch (this) {
      case Appearance.light:
        return ThemeMode.light;
      case Appearance.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

abstract class Measurement {
  UnitSystem get system;
  double get min;
  double get max;
  int get divisions;
  double get value;
  set value(double value);

  @override
  String toString();
}

class Height implements Measurement {
  final double conversionFactor = 2.54;
  final double cmMin = 120;
  final double cmMax = 220;
  double get inchMin => cmMin / conversionFactor;
  double get inchMax => cmMax / conversionFactor;

  int get cmDivisions => (cmMax - cmMin).round();
  int get inchDivisions => (inchMax - inchMin).round();

  HeightUnit unit;
  double cm;

  double get inches => cm / conversionFactor;
  set inches(double inches) {
    cm = inches * conversionFactor;
  }

  // Measurement Class Properties
  //(for a slider to read without having to handle units on its end)
  @override
  double get value {
    switch (system) {
      case UnitSystem.metric:
        return cm;
      case UnitSystem.imperial:
        return inches;
    }
  }

  @override
  set value(double value) {
    switch (system) {
      case UnitSystem.metric:
        cm = value;
        break;
      case UnitSystem.imperial:
        inches = value;
        break;
    }
  }

  @override
  int get divisions {
    switch (system) {
      case UnitSystem.metric:
        return cmDivisions;
      case UnitSystem.imperial:
        return inchDivisions;
    }
  }

  @override
  double get max {
    switch (system) {
      case UnitSystem.metric:
        return cmMax;
      case UnitSystem.imperial:
        return inchMax;
    }
  }

  @override
  double get min {
    switch (system) {
      case UnitSystem.metric:
        return cmMin;
      case UnitSystem.imperial:
        return inchMin;
    }
  }

  @override
  UnitSystem get system {
    if (unit == HeightUnit.centimetres || unit == HeightUnit.metres) {
      return UnitSystem.metric;
    } else {
      return UnitSystem.imperial;
    }
  }

  // Display Properties (get only)
  int get metres => ((cm - cm % 100) / 100).round();
  int get cmSubMetres => (cm % 100).round();
  int get feet => ((inches - inches % 12) / 12).round();
  int get inchesSubFeet => (inches % 12).round();

  @override
  String toString() {
    switch (unit) {
      case HeightUnit.centimetres:
        return "${cm.round()}cm";
      case HeightUnit.metres:
        return "${cm.round() / 100}m";
      case HeightUnit.inches:
        return "${inches.round()}\"";
      case HeightUnit.feet:
        return "$feet'$inchesSubFeet\"";
    }
  }

  Height({required this.cm, required this.unit});
}

class Weight implements Measurement {
  final double conversionFactor = 2.205;
  final double kgMin = 35;
  final double kgMax = 275;
  double get lbsMin => kgMin * conversionFactor;
  double get lbsMax => kgMax * conversionFactor;

  int get kgDivisions => (kgMax - kgMin).round();
  int get lbsDivisions => (lbsMax - lbsMin).round();

  WeightUnit unit;
  double kg;

  double get lbs => kg * conversionFactor;
  set lbs(double lbs) {
    kg = lbs / conversionFactor;
  }

  @override
  double get value {
    switch (system) {
      case UnitSystem.metric:
        return kg;
      case UnitSystem.imperial:
        return lbs;
    }
  }

  @override
  set value(double value) {
    switch (system) {
      case UnitSystem.metric:
        kg = value;
        break;
      case UnitSystem.imperial:
        lbs = value;
        break;
    }
  }

  @override
  int get divisions {
    switch (system) {
      case UnitSystem.metric:
        return kgDivisions;
      case UnitSystem.imperial:
        return lbsDivisions;
    }
  }

  @override
  double get max {
    switch (system) {
      case UnitSystem.metric:
        return kgMax;
      case UnitSystem.imperial:
        return lbsMax;
    }
  }

  @override
  double get min {
    switch (system) {
      case UnitSystem.metric:
        return kgMin;
      case UnitSystem.imperial:
        return lbsMin;
    }
  }

  @override
  UnitSystem get system {
    switch (unit) {
      case WeightUnit.kg:
        return UnitSystem.metric;
      default:
        return UnitSystem.imperial;
    }
  }

  int get lbsSubStone => (lbs % 14).round();
  int get stone => ((lbs - lbs % 14) / 14).round();

  @override
  String toString() {
    switch (unit) {
      case WeightUnit.kg:
        return "${kg.round()}kg";
      case WeightUnit.lbs:
        return "${lbs.round()}lbs";
      case WeightUnit.stone:
        return "${stone}st ${lbsSubStone}lbs";
    }
  }

  Weight({required this.kg, required this.unit});
}

class Energy implements Measurement {
  final double conversionFactor = 4.184;
  final double calMin = 1000;
  final double calMax = 10000;
  double get joulesMin => calMin * conversionFactor;
  double get joulesMax => calMax * conversionFactor;

  int get calDivisions => ((calMax - calMin) / 50).round();
  int get joulesDivisions => (joulesMax - joulesMin / 50).round();

  double cal;
  EnergyUnit unit;

  double get joules {
    return cal * conversionFactor;
  }

  set joules(double joules) {
    cal = joules / conversionFactor;
  }

  @override
  double get value {
    switch (unit) {
      case EnergyUnit.joules:
        return joules;
      default:
        return cal;
    }
  }

  @override
  set value(double value) {
    switch (unit) {
      case EnergyUnit.joules:
        joules = value;
        break;
      default:
        cal = value;
        break;
    }
  }

  @override
  int get divisions {
    switch (unit) {
      case EnergyUnit.joules:
        return joulesDivisions;
      default:
        return calDivisions;
    }
  }

  @override
  double get max {
    switch (unit) {
      case EnergyUnit.joules:
        return joulesMax;
      default:
        return calMax;
    }
  }

  @override
  double get min {
    switch (unit) {
      case EnergyUnit.joules:
        return joulesMin;
      default:
        return calMin;
    }
  }

  @override
  // All energy units are metric, so Energy.system always returns metric
  UnitSystem get system => UnitSystem.metric;

  @override
  String toString() {
    switch (unit) {
      case EnergyUnit.calories:
        return "${cal.round()} kcal";
      case EnergyUnit.joules:
        return "${joules.round()} joules";
    }
  }

  Energy({required this.cal, required this.unit});
}

class Settings {
  final int id;
  late Energy energy;
  late Height height;
  late Weight weight;
  Appearance appearance;

  Settings(
      {required this.id,
      required double cal,
      required double cm,
      required double kg,
      required HeightUnit heightUnit,
      required WeightUnit weightUnit,
      required EnergyUnit energyUnit,
      required this.appearance}) {
    height = Height(cm: cm, unit: heightUnit);
    weight = Weight(kg: kg, unit: weightUnit);
    energy = Energy(cal: cal, unit: energyUnit);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'energy': energy.cal,
      'height': height.cm,
      'weight': weight.kg,
      'heightUnit': height.unit.index,
      'weightUnit': weight.unit.index,
      'energyUnit': energy.unit.index,
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
          'CREATE TABLE settings(id INTEGER PRIMARY KEY, energy FLOAT, height FLOAT, weight FLOAT, heightUnit INT, weightUnit INT, energyUnit INT, appearance INT)',
        );
        await db.insert('settings', {
          'energy': 2000.0,
          'height': 170.0,
          'weight': 60.0,
          'heightUnit': HeightUnit.centimetres.index,
          'weightUnit': WeightUnit.kg.index,
          'energyUnit': EnergyUnit.calories.index,
          'appearance': Appearance.system.index
        });
      },
      version: 2,
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
        cal: maps[0]['energy'],
        cm: maps[0]['height'],
        kg: maps[0]['weight'],
        heightUnit: HeightUnit.values[maps[0]['heightUnit']],
        weightUnit: WeightUnit.values[maps[0]['weightUnit']],
        energyUnit: EnergyUnit.values[maps[0]['energyUnit']],
        appearance: Appearance.values[maps[0]['appearance']]);
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
