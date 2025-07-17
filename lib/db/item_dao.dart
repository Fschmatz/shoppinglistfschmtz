import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ItemDao {
  static const _databaseName = "ShopList.db";
  static const _databaseVersion = 1;

  static const table = 'items';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnIdShopList = 'idShopList';

  ItemDao._privateConstructor();

  static final ItemDao instance = ItemDao._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getItemsShopList(int idShopList) async {
    Database db = await instance.database;
    return await db.rawQuery('''
        SELECT * FROM $table 
        WHERE idShopList=$idShopList    
        ORDER BY $columnName COLLATE NOCASE
        ''');
  }

  Future<List<Map<String, dynamic>>> getItemsShopListDoOrderName(int idShopList) async {
    Database db = await instance.database;
    return await db.rawQuery('''
        SELECT * FROM $table 
        WHERE idShopList=$idShopList 
        ORDER BY $columnName COLLATE NOCASE
        ''');
  }

  Future<List<Map<String, dynamic>>> getItemsShopListDoneOrderName(int idShopList) async {
    Database db = await instance.database;
    return await db.rawQuery('''
        SELECT * FROM $table 
        WHERE idShopList=$idShopList       
        ORDER BY $columnName COLLATE NOCASE
        ''');
  }
}
