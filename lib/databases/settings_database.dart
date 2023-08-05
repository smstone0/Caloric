import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Settings {
  final int id;
  double calorieGoal;
  double height;
  double weight;
  String unit;
  String mode;

  Settings(
      {required this.id,
      required this.calorieGoal,
      required this.height,
      required this.weight,
      required this.unit,
      required this.mode});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calorieGoal': calorieGoal,
      'height': height,
      'weight': weight,
      'unit': unit,
      'mode': mode,
    };
  }
}

class SettingsDatabase {
  Future<Database> openDatabaseConnection() async {
    return openDatabase(
      join(await getDatabasesPath(), 'settings_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE settings(id INTEGER PRIMARY KEY, calorieGoal FLOAT, height FLOAT, weight FLOAT, unit TEXT, mode TEXT)',
        );
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

  Future<List<Settings>> getSettings() async {
    final db = await openDatabaseConnection();
    final List<Map<String, dynamic>> maps = await db.query('settings');
    return List.generate(maps.length, (i) {
      return Settings(
        id: maps[i]['id'],
        calorieGoal: maps[i]['calorieGoal'],
        height: maps[i]['height'],
        weight: maps[i]['weight'],
        unit: maps[i]['unit'],
        mode: maps[i]['mode'],
      );
    });
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
