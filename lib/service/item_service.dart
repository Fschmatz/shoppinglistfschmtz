import 'package:shoppinglistfschmtz/db/item_dao.dart';
import 'package:shoppinglistfschmtz/service/store_service.dart';

import '../classes/item.dart';

class ItemService extends StoreService {
  final dbItem = ItemDao.instance;

  Future<void> insert(int idShopList, String name) async {
    Map<String, dynamic> row = {ItemDao.columnName: name, ItemDao.columnIdShopList: idShopList};

    await dbItem.insert(row);
    loadShopLists();
  }

  Future<void> update(Item item, String name) async {
    Map<String, dynamic> row = {ItemDao.columnId: item.id, ItemDao.columnName: name, ItemDao.columnIdShopList: item.idShopList};

    await dbItem.update(row);
    loadShopLists();
  }

  Future<void> delete(int id) async {
    await dbItem.delete(id);

    loadShopLists();
  }
}
