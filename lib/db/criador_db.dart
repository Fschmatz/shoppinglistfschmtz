import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CriadorDb {
  static const _databaseName = "ShopList.db";
  static const _databaseVersion = 1;

  CriadorDb._privateConstructor();

  static final CriadorDb instance = CriadorDb._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE shoplists (          
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,            
            color TEXT NOT NULL                     
          )          
          ''');

    await db.execute('''
          CREATE TABLE items (          
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,         
            idShopList INTEGER NOT NULL,   
            FOREIGN KEY (idShopList) REFERENCES shoplists (_id)                   
          )
          ''');

    //TRIGGER delete items on ShopListlist Delete
    await db.execute('''
          CREATE TRIGGER deleteItemsShopList
          AFTER DELETE ON shoplists           
          BEGIN
            DELETE FROM items WHERE idShopList=old.id;
          END;          
          ''');

    // CREATE DEFAULT SHOPLIST
    Batch batch = db.batch();

    batch.insert('shoplists', {'id': 1, 'name': 'My shop list', 'color': '0xFF607D8B'});
    batch.insert('items', {'id': 1, 'name': 'Steel', 'idShopList': '1'});
    batch.insert('items', {'id': 2, 'name': 'Silver', 'idShopList': '1'});

    batch.insert('shoplists', {'id': 2, 'name': 'Steam', 'color': '0xFFE91E63'});
    batch.insert('items', {'id': 3, 'name': 'Bloodborne', 'idShopList': '2'});

    await batch.commit(noResult: true);
  }
}
