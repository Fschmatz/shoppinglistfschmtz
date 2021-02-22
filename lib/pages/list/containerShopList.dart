import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/pages/editShopList.dart';
import 'package:shoppinglistfschmtz/pages/list/containerItemShopListView.dart';
import 'package:shoppinglistfschmtz/db/itemDao.dart';
import 'package:shoppinglistfschmtz/pages/newShopList.dart';

class ContainerShopList extends StatefulWidget {
  @override
  _ContainerShopListState createState() => _ContainerShopListState();

  ShopList shopList;
  Function() refreshShopLists;

  ContainerShopList({Key key, this.shopList, this.refreshShopLists})
      : super(key: key);
}

class _ContainerShopListState extends State<ContainerShopList> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    getItemsShopList();
    super.initState();
  }

  Future<void> getItemsShopList() async {
    final dbItems = itemDao.instance;
    var resposta = await dbItems.getItemsShopList(widget.shopList.id);

    //SetState error call, use if mounted
    if (mounted) {
      setState(() {
        items = resposta;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(
          color: Color(int.parse(widget.shopList.cor.substring(6, 16)))
              .withOpacity(0.7),
          width: 1.8,
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
              ));

        },
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(28, 20, 16, 5),
                alignment: Alignment.topLeft,
                child: Text(
                  widget.shopList.nome,
                  style:
                      TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
                )),
            const Divider(
              thickness: 1.8,
              indent: 15,
              endIndent: 15,
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ContainerItemShopListView(
                    item: new Item(
                      id: items[index]['id'],
                      nome: items[index]['nome'],
                      quantity: items[index]['quantity'],
                      estado: items[index]['estado'],
                      idShopList: items[index]['idShopList'],
                    ),
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
