import 'package:shoppinglistfschmtz/db/item_dao.dart';
import 'package:shoppinglistfschmtz/service/store_service.dart';

class ItemService extends StoreService {
  final dbItem = ItemDao.instance;

  Future<void> insert(int idShopList, String name) async {
    Map<String, dynamic> row = {ItemDao.columnName: name, ItemDao.columnIdShopList: idShopList};

    await dbItem.insert(row);
    loadShopLists();
  }

  Future<void> delete(int id) async {
    await dbItem.delete(id);

    loadShopLists();
  }
}
