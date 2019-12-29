import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Lamp.dart';

class DatabaseService {
  Database _database;

  void setupDatabase() async {
    Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'lamp_database.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE lamps(name TEXT PRIMARY KEY, type TEXT, pin INTEGER)');
      },
      version: 1,
    );
    this._database = await database;
  }

  Future<void> insertLamp(Lamp lamp) async {
    if (_database == null) await setupDatabase();

    await _database.insert('lamps', lamp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Lamp>> getLamps() async {
    if (_database == null) await setupDatabase();

    List<Map<String, dynamic>> maps = await _database.query('lamps');

    return List.generate(maps.length, (i) {
      return Lamp(
        name: maps[i]['name'],
        type: maps[i]['type'],
        pin: maps[i]['pin'],
      );
    });
  }

  Future<void> deleteLamp(String name) async {
    if (_database == null) await setupDatabase();

    await _database.delete(
      'lamps',
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}
