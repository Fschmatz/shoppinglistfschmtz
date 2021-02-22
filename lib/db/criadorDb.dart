import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class criadorDb {

  static final _databaseName = "ShopList.db";
  static final _databaseVersion = 1;

  criadorDb._privateConstructor(); //_privateConstructor
  static final criadorDb instance = criadorDb._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // instancia o db na primeira vez que for acessado
    _database = await initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  initDatabase() async { //_initDatabase();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // Código SQL para criar o banco de dados e a tabela,
  // só roda uma vez quando detecta banco nulo
  Future _onCreate(Database db, int version) async {
    print("OI DO CRIADOR DE DB");

    await db.execute('''
    
          CREATE TABLE shoplists (          
            id INTEGER PRIMARY KEY,
            nome TEXT NOT NULL,            
            cor TEXT NOT NULL                     
          )
          
          ''');

    await db.execute('''
          CREATE TABLE items (
          
            id INTEGER PRIMARY KEY,
            nome TEXT NOT NULL,   
            quantity INTEGER,         
            estado INTEGER NOT NULL,
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


    Batch batch = db.batch();
    batch.insert('shoplists', {'id': 1,'nome': 'Mercado','cor': 'Color(0xFF4CAF50)'});
    batch.insert('shoplists', {'id': 2,'nome': 'Inferno','cor': 'Color(0xFFFF5252)'});
    batch.insert('shoplists', {'id': 3,'nome': 'Loja de Amendoim','cor': 'Color(0xFF82B1FF)'});

    batch.insert('items', {'id': 1,'nome': 'Pão','quantity':'1','estado': 0, 'idShopList':'1'});
    batch.insert('items', {'id': 2,'nome': 'Sal','quantity':'5','estado': 1, 'idShopList':'1'});

    batch.insert('items', {'id': 3,'nome': 'Cabeças','quantity':'5','estado': 0, 'idShopList':'2'});
    batch.insert('items', {'id': 4,'nome': 'Fogo','quantity':'2','estado': 0, 'idShopList':'2'});
    batch.insert('items', {'id': 5,'nome': 'Sofrimento','quantity':'9','estado': 1, 'idShopList':'2'});

    batch.insert('items', {'id': 6,'nome': 'Agridoce','quantity':'5','estado': 0, 'idShopList':'3'});
    batch.insert('items', {'id': 7,'nome': 'Defumado','quantity':'2','estado': 0, 'idShopList':'3'});
    batch.insert('items', {'id': 8,'nome': 'Salgado','quantity':'9','estado': 1, 'idShopList':'3'});
    batch.insert('items', {'id': 9,'nome': 'Mostarda','quantity':'10','estado': 1, 'idShopList':'3'});
    batch.insert('items', {'id': 10,'nome': 'Acebolado','quantity':'25','estado': 1, 'idShopList':'3'});

    await batch.commit(noResult: true);

  }
}

