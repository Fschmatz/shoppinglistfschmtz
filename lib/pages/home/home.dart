import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/db/shopListDao.dart';
import 'package:shoppinglistfschmtz/pages/home/shopListHome.dart';
import 'package:shoppinglistfschmtz/pages/new/newShopList.dart';
import '../../configs/configs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  Home({Key key}) : super(key: key);
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> shopLists = [];
  int lastId;

  @override
  void initState() {
    getShopLists();
    getLastId();
    super.initState();
  }

  Future<void> getShopLists() async {
    final dbShopList = shopListDao.instance;
    var resposta = await dbShopList.queryAllRows();
    setState(() {
      shopLists = resposta;
    });
  }

  Future<void> getLastId() async {
    final dbShopList = shopListDao.instance;
    var resposta = await dbShopList.getLastId();
    setState(() {
      if (resposta.isEmpty) {
        lastId = 0;
      } else {
        lastId = resposta[0]['id'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: ListView(children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        shopLists.isEmpty
            ? SizedBox.shrink()
            : ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: shopLists.length,
                itemBuilder: (context, index) {
                  return ShopListHome(
                    refreshShopLists: getShopLists,
                    key: UniqueKey(), //USADO pro REFRESH GERAL
                    shopList: new ShopList(
                      id: shopLists[index]['id'],
                      nome: shopLists[index]['nome'],
                      cor: shopLists[index]['cor'],
                    ),
                  );
                },
              ),
        const SizedBox(
          height: 50,
        ),
      ]),

      //BOTTOMBAR
      floatingActionButton: Container(
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            elevation: 6,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => NewShopList(
                      lastId: lastId,
                      refreshShopLists: getShopLists,
                    ),
                    fullscreenDialog: true,
                  )).then((value) => getLastId());
            },
            child: Icon(
              Icons.playlist_add,
              size: 27,
              //color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      bottomNavigationBar: BottomAppBar(
        notchMargin: 4,
          shape: CircularNotchedRectangle(),
          child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), //24
            child: IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 24,
                ),
                tooltip: "Settings",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Configs(),
                        fullscreenDialog: true,
                      ));
                }),
          ),
        ],
      )),
    );
  }
}
