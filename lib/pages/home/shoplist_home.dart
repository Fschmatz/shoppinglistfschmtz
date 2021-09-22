import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';
import 'package:shoppinglistfschmtz/pages/edit/edit_shoplist.dart';
import 'package:shoppinglistfschmtz/pages/home/item_shoplist_home.dart';

class ShopListHome extends StatefulWidget {
  @override
  _ShopListHomeState createState() => _ShopListHomeState();

  ShopList shopList;
  Function() refreshShopLists;
  Function() resetController;
  bool showItemCount;

  ShopListHome({Key key, this.shopList, this.refreshShopLists,this.resetController,this.showItemCount})
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
    if (mounted) {
      setState(() {
        items = resposta;
      });
    }
  }

  Future<void> getItemsRefreshShopList(int idShopList) async {
    final dbItems = ItemDao.instance;
    var resposta = await dbItems.getItemsShopListDoDesc(idShopList);
    if (mounted) {
      setState(() {
        items = resposta;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          onTap: () {
            widget.resetController();
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => EditShopList(
                    refreshShopLists: widget.refreshShopLists,
                    shopList: widget.shopList,
                  ),
                  fullscreenDialog: true,
                )).then((value) => widget.refreshShopLists());
          },
          leading: Icon(
            Icons.shopping_cart_outlined,
            color: shopListColor,
          ),
          title: Text(
            widget.shopList.nome.toUpperCase(),
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700,color: shopListColor),
          ),
          trailing: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Visibility(
              visible: widget.showItemCount,
              child: Text(
                items.length.toString(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context)
                        .textTheme
                        .headline6
                        .color
                        .withOpacity(0.7)),
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

