import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';
import 'package:shoppinglistfschmtz/pages/edit/edit_shoplist.dart';
import 'package:shoppinglistfschmtz/pages/home/item_shoplist_home.dart';
import 'package:flutter_animator/flutter_animator.dart';

class ShopListHome extends StatefulWidget {
  @override
  _ShopListHomeState createState() => _ShopListHomeState();

  ShopList shopList;
  Function() refreshShopLists;

  ShopListHome({Key? key, required this.shopList, required this.refreshShopLists}) : super(key: key);
}

class _ShopListHomeState extends State<ShopListHome> with AutomaticKeepAliveClientMixin<ShopListHome> {
  @override
  bool get wantKeepAlive => true;

  bool loading = true;
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
    items = await dbItems.getItemsShopListDoOrderName(widget.shopList.id);

    setState(() {
      loading = false;
    });
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
    super.build(context);
    final currentScheme = Theme.of(context).brightness == Brightness.light
        ? ColorScheme.fromSeed(seedColor: shopListColor)
        : ColorScheme.fromSeed(seedColor: shopListColor, brightness: Brightness.dark);
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
                leading: Icon(
                  Icons.shopping_cart_outlined,
                  color: currentScheme.primary,
                ),
                minLeadingWidth: 35,
                title: Text(
                  widget.shopList.nome.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: currentScheme.primary,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: loading
                    ? const SizedBox(
                        height: 50,
                      )
                    : ListView.separated(
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(
                              height: 2,
                            ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          bool isFirst = index == 0 && items.length > 1;
                          bool isLast = index == items.length - 1;
                          bool isOnlyOneItem = items.length == 1;

                          RoundedRectangleBorder border = RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          );

                          if (isFirst) {
                            border = const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                            );
                          } else if (isOnlyOneItem) {
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
