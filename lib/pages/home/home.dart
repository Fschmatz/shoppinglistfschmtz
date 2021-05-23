import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/configs/appInfoPage.dart';
import 'package:shoppinglistfschmtz/db/shopListDao.dart';
import 'package:shoppinglistfschmtz/pages/home/shopListHome.dart';
import 'package:shoppinglistfschmtz/pages/new/newShopList.dart';
import '../../configs/settingsPage.dart';

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
    var resposta = await dbShopList.queryAllOrderByName();
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
      appBar: AppBar(
        title: Text('ShopList'),
        elevation: 0,
      ),
      body: ListView(children: <Widget>[
        const SizedBox(
          height: 5,
        ),
        shopLists.isEmpty
            ? SizedBox.shrink()
            : ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: shopLists.length,
                itemBuilder: (context, index) {
                  return ShopListHome(
                    refreshShopLists: getShopLists,
                    key: UniqueKey(),
                    shopList: new ShopList(
                      id: shopLists[index]['id'],
                      nome: shopLists[index]['nome'],
                      cor: shopLists[index]['cor'],
                    ),
                  );
                },
              ),
        const SizedBox(
          height: 100,
        ),
      ]),
      floatingActionButton: Container(
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 0.0,
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
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .headline6
                          .color
                          .withOpacity(0.7),
                    ),
                    splashRadius: 28,
                    tooltip: "Settings",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => SettingsPage(),
                            fullscreenDialog: true,
                          ));
                    }),
              ],
            ),
          )),
    );
  }
}
