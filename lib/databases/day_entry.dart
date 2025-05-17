import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../functions/dates.dart';

class DayEntry {
  final int id;
  String itemName;
  String dateLogged;
  String? recordedByUnit; // e.g. g, ml, slice
  double? amount; // e.g. 60g, 2 slices, 0.5 cups
  int totalKcal;

  DayEntry({
    required this.id,
    required this.itemName,
    required this.dateLogged,
    this.recordedByUnit,
    this.amount,
    required this.totalKcal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'dateLogged': dateLogged,
      'recordedByUnit': recordedByUnit,
      'amount': amount,
      'totalKcal': totalKcal,
    };
  }
}

class DayEntryDatabase {
  Future<Database> openDatabaseConnection() async {
    return openDatabase(
      join(await getDatabasesPath(), 'day_entry_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE day_entry(id INTEGER PRIMARY KEY, itemName TEXT, dateLogged TEXT, recordedByUnit TEXT, amount REAL, totalKcal INTEGER)',
        );
        await db.insert('day_entry', {
          'itemName': 'Sample Item',
          'dateLogged': getCurrentDate(),
          'recordedByUnit': null,
          'amount': null,
          'totalKcal': 100,
        });
      },
      version: 1,
    );
  }

  Future<void> insertDayEntry(DayEntry entry) async {
    final db = await openDatabaseConnection();
    await db.insert(
      'day_entry',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DayEntry>> getDayEntriesForDate(String date) async {
    final db = await openDatabaseConnection();
    final List<Map<String, dynamic>> maps = await db.query(
      'day_entry',
      where: "dateLogged LIKE ?",
      whereArgs: ['$date%'],
    );
    return List.generate(maps.length, (i) {
      return DayEntry(
        id: maps[i]['id'],
        itemName: maps[i]['itemName'],
        dateLogged: maps[i]['dateLogged'],
        recordedByUnit: maps[i]['recordedByUnit'],
        amount: maps[i]['amount'],
        totalKcal: maps[i]['totalKcal'],
      );
    });
  }

  Future<void> deleteDayEntry(int id) async {
    final db = await openDatabaseConnection();
    await db.delete(
      'day_entry',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}