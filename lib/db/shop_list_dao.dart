import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ShopListDao {

  static const _databaseName = "ShopList.db";
  static const _databaseVersion = 1;

  static const table = 'shoplists';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnColor = 'color';

  ShopListDao._privateConstructor();
  static final ShopListDao instance = ShopListDao._privateConstructor();

  static Database? _database;

  Future<Database> get database async =>
      _database ??= await _initDatabase();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
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

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllOrderByName() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY $columnName COLLATE NOCASE');
  }

  Future<List<Map<String, dynamic>>> getLastId() async {
    Database db = await instance.database;
    return await db.rawQuery('''    
        SELECT * FROM $table ORDER BY $columnId DESC LIMIT 1;        
        ''');
  }

  Future<List<Map<String, dynamic>>> queryAllShopListsWithItemsJoined() async {
    Database db = await instance.database;

    return await db.rawQuery('''
                  SELECT sl.*
                  ,      i.id as item_id 
                  ,      i.name as item_name                  
                  ,      i.idShopList 
                  FROM shoplists sl
                  LEFT JOIN items i ON sl.id = i.idShopList
                  ORDER BY sl.name COLLATE NOCASE 
                  ,        i.name COLLATE NOCASE
          ''');
  }
}