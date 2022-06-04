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
  bool showItemCount;

  ShopListHome(
      {Key key, this.shopList, this.refreshShopLists, this.showItemCount})
      : super(key: key);
}

class _ShopListHomeState extends State<ShopListHome> {
  List<Map<String, dynamic>> items = [];
  Color shopListColor;

  @override
  void initState() {
    getItemsShopList();
    shopListColor = Color(int.parse(widget.shopList.cor.substring(6, 16)));
    super.initState();
  }

  // ONLY DO ITEMS
  Future<void> getItemsShopList() async {
    final dbItems = ItemDao.instance;
    var resposta = await dbItems.getItemsShopListDoDesc(widget.shopList.id);
    if(mounted) {
      setState(() {
        items = resposta;
      });
    }
  }

  Future<void> getItemsRefreshShopList(int idShopList) async {
    final dbItems = ItemDao.instance;
    var resposta = await dbItems.getItemsShopListDoDesc(idShopList);
    setState(() {
      items = resposta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness _listNameTextBrightness = Theme.of(context).brightness;

    return Column(
      children: [
        ListTile(
          tileColor: shopListColor.withOpacity(0.15),
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
          leading: Icon(
            Icons.shopping_cart_outlined,
            color: _listNameTextBrightness == Brightness.dark
                ? lightenColor(shopListColor, 20)
                : darkenColor(shopListColor, 20),
          ),
          minLeadingWidth: 35,
          title: Text(
            widget.shopList.nome.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _listNameTextBrightness == Brightness.dark
                  ? lightenColor(shopListColor, 20)
                  : darkenColor(shopListColor, 20),
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Visibility(
              visible: widget.showItemCount,
              child: Text(
                items.length.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _listNameTextBrightness == Brightness.dark
                      ? lightenColor(shopListColor, 20)
                      : darkenColor(shopListColor, 20),
                ),
              ),
            ),
          ),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ItemShopListHome(
                item: Item(
                  id: items[index]['id'],
                  nome: items[index]['nome'],
                  estado: items[index]['estado'],
                  idShopList: items[index]['idShopList'],
                ),
                shopListColor: shopListColor,
                getItemsRefreshShopList: getItemsRefreshShopList,
                key: UniqueKey(),
              );
            }),
      ],
    );
  }
}
