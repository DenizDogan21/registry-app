import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../FrontEnd/Forms/form_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'forms.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS forms (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            turboNo INTEGER,
            tarih TEXT,
            aracBilgileri TEXT,
            musteriBilgileri TEXT,
            musteriSikayetleri TEXT,
            tespitEdilen TEXT,
            yapilanIslemler TEXT
            -- ... add the remaining fields
          )
        ''');
      },
    );
  }

  Future<int> insertForm(FormData formData) async {
    Database db = await database;
    return await db.insert('forms', formData.toMap());
  }

  Future<List<FormData>> getAllForms() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('forms');
    return List.generate(maps.length, (index) {
      return FormData.fromMap(maps[index]);
    });
  }
}
