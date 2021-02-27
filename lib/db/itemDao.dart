import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class itemDao {

  static final _databaseName = "ShopList.db";
  static final _databaseVersion = 1;

  static final table = 'items';
  static final columnId = 'id';
  static final columnNome = 'nome';
  static final columnEstado = 'estado'; // 0 or 1
  static final columnIdShopList = 'idShopList';

  itemDao._privateConstructor();
  static final itemDao instance = itemDao._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

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

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getItemsShopList(int idShopLista) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    
        SELECT * FROM $table 
        WHERE idShopList=$idShopLista     
        
        ''');
  }

  Future<List<Map<String, dynamic>>> getItemsShopListDo(int idShopLista) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    
        SELECT * FROM $table 
        WHERE idShopList=$idShopLista AND estado=0    
        
        ''');
  }

  Future<List<Map<String, dynamic>>> getItemsShopListDone(int idShopLista) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    
        SELECT * FROM $table 
        WHERE idShopList=$idShopLista AND estado=1      
        
        ''');
  }

}