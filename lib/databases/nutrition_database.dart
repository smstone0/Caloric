import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum NutType { food, drink }

class Nutrition {
  final int id;
  String item;
  int energy;
  NutType type;
  int quantity;
  String unit;
  String creationDate;

  Nutrition(
      {required this.id,
      required this.item,
      required this.energy,
      required this.type,
      required this.quantity,
      required this.unit,
      required this.creationDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item,
      'energy': energy,
      'type': type.index,
      'quantity': quantity,
      'unit': unit,
      'creationDate': creationDate,
    };
  }
}

class NutritionDatabase {
  Future<Database> openDatabaseConnection() async {
    return openDatabase(
      join(await getDatabasesPath(), 'nutrition_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE nutrition(id INTEGER PRIMARY KEY, item STRING, energy INT, type INT, quantity INT, unit STRING, creationDate STRING)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertNutrition(Nutrition nutrition) async {
    final db = await openDatabaseConnection();
    await db.insert(
      'nutrition',
      nutrition.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Nutrition>> getNutrition() async {
    final db = await openDatabaseConnection();
    final List<Map<String, dynamic>> maps = await db.query('nutrition');
    return List.generate(maps.length, (i) {
      return Nutrition(
        id: maps[i]['id'],
        item: maps[i]['item'],
        energy: maps[i]['energy'],
        type: NutType.values[maps[i]['type']],
        quantity: maps[i]['quantity'],
        unit: maps[i]['unit'],
        creationDate: maps[i]['creationDate'],
      );
    });
  }

  Future<void> updateNutrition(Nutrition nutrition) async {
    final db = await openDatabaseConnection();
    await db.update(
      'nutrition',
      nutrition.toMap(),
      where: 'id = ?',
      whereArgs: [nutrition.id],
    );
  }

  Future<void> deleteNutrition(int id) async {
    final db = await openDatabaseConnection();
    await db.delete(
      'nutrition',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
