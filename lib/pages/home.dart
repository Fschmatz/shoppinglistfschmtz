import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/db/shopListDao.dart';
import 'package:shoppinglistfschmtz/pages/list/containerShopList.dart';
import 'package:shoppinglistfschmtz/pages/newShopList.dart';
import '../configs/configs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  Home({Key key}) : super(key: key);
}

class _HomeState extends State<Home> {
  //bool carregando = true;
  List<Map<String, dynamic>> shopLists = [];

  @override
  void initState() {
    getShopLists();
    super.initState();
  }

  Future<void> getShopLists() async {
    final dbShopList = shopListDao.instance;
    var resposta = await dbShopList.queryAllRows();
    setState(() {
      shopLists = resposta;
    });
  }

  void refreshShopLists() {
    getShopLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomPadding: false,
      body: ListView(children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: shopLists.length,
                itemBuilder: (context, index) {
                  return ContainerShopList(
                    refreshShopLists: refreshShopLists,
                    key: UniqueKey(), //USADO pro REFRESH GERAL
                    shopList: new ShopList(
                      id: shopLists[index]['id'],
                      nome: shopLists[index]['nome'],
                      cor: shopLists[index]['cor'],
                    ),
                  );
                },
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
                      refreshShopLists: refreshShopLists,
                    ),
                    fullscreenDialog: true,
                  ));
            },
            child: Icon(
              Icons.playlist_add,
              size:28,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      bottomNavigationBar: BottomAppBar(
          //shape: CircularNotchedRectangle(),
          //notchMargin: 10,

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
