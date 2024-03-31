import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';
import 'package:shoppinglistfschmtz/pages/edit/edit_shoplist.dart';
import 'package:shoppinglistfschmtz/pages/home/item_shoplist_home.dart';

import '../../util/utils_functions.dart';

class ShopListHome extends StatefulWidget {
  @override
  _ShopListHomeState createState() => _ShopListHomeState();

  ShopList shopList;
  Function() refreshShopLists;

  ShopListHome({Key? key, required this.shopList, required this.refreshShopLists}) : super(key: key);
}

class _ShopListHomeState extends State<ShopListHome> {
  List<Map<String, dynamic>> items = [];
  late Color shopListColor;

  @override
  void initState() {
    super.initState();

    getItemsShopList();
    shopListColor = Color(int.parse(widget.shopList.cor.substring(6, 16)));
  }

  Future<void> getItemsShopList() async {
    final dbItems = ItemDao.instance;
    var resposta = await dbItems.getItemsShopListDoOrderName(widget.shopList.id);
    if (mounted) {
      setState(() {
        items = resposta;
      });
    }
  }

  Future<void> getItemsRefreshShopList(int idShopList) async {
    final dbItems = ItemDao.instance;
    var resposta = await dbItems.getItemsShopListDoOrderName(idShopList);
    setState(() {
      items = resposta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentScheme =
    Theme.of(context).brightness == Brightness.light ? ColorScheme.fromSeed(seedColor: shopListColor) : ColorScheme.fromSeed(seedColor: shopListColor, brightness: Brightness.dark);
    Color tileColor = currentScheme.surfaceVariant;

    return Theme(
      data: ThemeData(
        colorScheme: currentScheme,
        useMaterial3: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Card(
          child: Column(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditShopList(
                          shopList: widget.shopList,
                        ),
                      )).then((value) => widget.refreshShopLists());
                },
                leading: const Icon(
                  Icons.shopping_cart_outlined,
                ),
                minLeadingWidth: 35,
                title: Text(
                  widget.shopList.nome.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(
                        height: 2,
                      ),                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    bool isFirst = index == 0 && items.length > 1;
                    bool isLast = index == items.length - 1;
                    bool isOnly = items.length == 1;

                    RoundedRectangleBorder border = RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    );

                    if (isFirst) {
                      border = const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                      );
                    } else if (isOnly) {
                      border = RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      );
                    } else if (isLast) {
                      border = const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                      );
                    }

                    return ItemShopListHome(
                      key: UniqueKey(),
                      item: Item(
                        id: items[index]['id'],
                        nome: items[index]['nome'],
                        estado: items[index]['estado'],
                        idShopList: items[index]['idShopList'],
                      ),
                      tileColor: tileColor,
                      getItemsRefreshShopList: getItemsRefreshShopList,
                      cardBorderRadius: border,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
