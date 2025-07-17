import 'package:shoppinglistfschmtz/db/item_dao.dart';

import '../main.dart';
import '../redux/actions.dart';

class ItemService {
  final dbItem = ItemDao.instance;

  Future<void> _reloadShopLists() async {
    await store.dispatch(LoadShopListsAction());
  }

  Future<void> insert(int idShopList, String name) async {
    Map<String, dynamic> row = {ItemDao.columnName: name, ItemDao.columnIdShopList: idShopList};

    await dbItem.insert(row);
    await _reloadShopLists();
  }

  Future<void> delete(int id) async {
    await dbItem.delete(id);
    await _reloadShopLists();
  }
}
