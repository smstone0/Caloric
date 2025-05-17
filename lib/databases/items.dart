import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../functions/dates.dart';

enum Unit { g, ml }

class Item {
  final int id;
  String itemName;
  String dateSaved;
  int? kcalPer100Unit;
  Unit? unit;
  String? customUnitName;
  int? kcalPerCustomUnit;

  Item({
    required this.id,
    required this.itemName,
    required this.dateSaved,
    this.kcalPer100Unit,
    this.unit,
    this.customUnitName,
    this.kcalPerCustomUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'dateSaved': dateSaved,
      'kcalPer100': kcalPer100Unit,
      'unit': unit?.index,
      'customUnitName': customUnitName,
      'kcalPerCustomUnit': kcalPerCustomUnit,
    };
  }
}

class ItemDatabase {
  Future<Database> openDatabaseConnection() async {
    return openDatabase(
      join(await getDatabasesPath(), 'item_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE item(id INTEGER PRIMARY KEY, itemName TEXT, dateSaved TEXT, kcalPer100 INTEGER, unit INTEGER, customUnitName TEXT, kcalPerCustomUnit INTEGER)',
        );
        //TODO: Remove this sample data
        await db.insert('item', {
          'itemName': 'Sample Item',
          'dateSaved': getCurrentDate(),
          'kcalPer100': 100,
          'unit': Unit.g.index,
          'customUnitName': null,
          'kcalPerCustomUnit': null,
        });
      },
      version: 1,
    );
  }

  Future<void> insertItem(Item item) async {
    final db = await openDatabaseConnection();
    await db.insert(
      'item',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> getItems() async {
    final db = await openDatabaseConnection();
    final List<Map<String, dynamic>> maps = await db.query('item');
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        itemName: maps[i]['itemName'],
        dateSaved: maps[i]['dateSaved'],
        kcalPer100Unit: maps[i]['kcalPer100'],
        unit: maps[i]['unit'] != null ? Unit.values[maps[i]['unit']] : null,
        customUnitName: maps[i]['customUnitName'],
        kcalPerCustomUnit: maps[i]['kcalPerCustomUnit'],
      );
    });
  }

  Future<void> updateItem(Item item) async {
    final db = await openDatabaseConnection();
    await db.update(
      'item',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await openDatabaseConnection();
    await db.delete(
      'item',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
