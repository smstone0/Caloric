import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum NutType { food, drink }

class Nutrition {
  final int id;
  String name;
  int calories;
  NutType type;
  String unitOfQuantity;
  String creationDate;

  Nutrition(
      {required this.id,
      required this.name,
      required this.calories,
      required this.type,
      required this.unitOfQuantity,
      required this.creationDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'type': type.index,
      'unitOfQuantity': unitOfQuantity,
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
          'CREATE TABLE nutrition(id INTEGER PRIMARY KEY, name STRING, calories INT, type INT, unitOfQuantity STRING, creationDate STRING)',
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
        name: maps[i]['name'],
        calories: maps[i]['calories'],
        type: NutType.values[maps[i]['type']],
        unitOfQuantity: maps[i]['unitOfQuantity'],
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
