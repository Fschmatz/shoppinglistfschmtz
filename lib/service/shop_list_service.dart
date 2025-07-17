import 'dart:ui';

import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/service/store_service.dart';

import '../classes/item.dart';
import '../db/shop_list_dao.dart';
import '../util/utils.dart';

class ShopListService extends StoreService {
  final dbShopList = ShopListDao.instance;

  Future<List<ShopList>> queryAllWithItems() async {
    final data = await dbShopList.queryAllShopListsWithItemsJoined();

    final Map<int, ShopList> shopListMap = {};

    for (final row in data) {
      final shopListId = row['id'] as int;

      if (!shopListMap.containsKey(shopListId)) {
        final shopList = ShopList.fromMap(row)..items = [];
        shopListMap[shopListId] = shopList;
      }

      if (row['item_id'] != null) {
        final itemMap = {
          'id': row['item_id'],
          'name': row['item_name'],
          'idShopList': row['idShopList'],
        };

        final item = Item.fromMap(itemMap);
        shopListMap[shopListId]!.items?.add(item);
      }
    }

    return shopListMap.values.toList();
  }

  Future<void> insert(String name, Color selectedColor) async {
    Map<String, dynamic> row = {ShopListDao.columnName: name, ShopListDao.columnColor: Utils().parseColorStringFromPicker(selectedColor)};

    await dbShopList.insert(row);
    loadShopLists();
  }

  Future<void> delete(int id) async {
    await dbShopList.delete(id);
    loadShopLists();
  }

  Future<void> update(int id, String name, Color selectedColor) async {
    Map<String, dynamic> row = {
      ShopListDao.columnId: id,
      ShopListDao.columnName: name,
      ShopListDao.columnColor: Utils().parseColorStringFromPicker(selectedColor),
    };

    await dbShopList.update(row);
    loadShopLists();
  }
}
