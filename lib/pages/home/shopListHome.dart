import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/db/itemDao.dart';
import 'package:shoppinglistfschmtz/pages/edit/editShopList.dart';
import 'package:shoppinglistfschmtz/pages/home/itemShopListHome.dart';

class ShopListHome extends StatefulWidget {
  @override
  _ShopListHomeState createState() => _ShopListHomeState();

  ShopList shopList;
  Function() refreshShopLists;

  ShopListHome({Key key, this.shopList, this.refreshShopLists})
      : super(key: key);
}

class _ShopListHomeState extends State<ShopListHome> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    getItemsShopList();
    super.initState();
  }

  // ONLY DO ITEMS
  Future<void> getItemsShopList() async {
    final dbItems = itemDao.instance;
    var resposta = await dbItems.getItemsShopListDoDesc(widget.shopList.id);
    if (mounted) {
      setState(() {
        items = resposta;
      });
    }
  }

  Future<void> getItemsRefreshShopList(int idShopList) async {
    final dbItems = itemDao.instance;
    var resposta = await dbItems.getItemsShopListDoDesc(idShopList);
    if (mounted) {
      setState(() {
        items = resposta;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(
          color: Color(int.parse(widget.shopList.cor.substring(6, 16)))
              .withOpacity(0.7),
          width: 1.25,
        ),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    EditShopList(
                      refreshShopLists:
                      widget.refreshShopLists,
                      shopList: widget.shopList,
                    ),
                fullscreenDialog: true,
              )).then((value) => widget.refreshShopLists());
        },
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(28, 20, 16, 5),
                alignment: Alignment.topLeft,
                child: Text(
                  widget.shopList.nome,
                  style:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                )),
            const SizedBox(height: 7,),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ItemShopListHome(
                    item: new Item(
                      id: items[index]['id'],
                      nome: items[index]['nome'],
                      estado: items[index]['estado'],
                      idShopList: items[index]['idShopList'],
                    ),
                    getItemsRefreshShopList: getItemsRefreshShopList,
                    key: UniqueKey(),
                  );
                }),
            const SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
