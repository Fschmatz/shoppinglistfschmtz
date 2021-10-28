import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/db/shoplist_dao.dart';
import 'package:shoppinglistfschmtz/pages/home/shoplist_home.dart';
import 'package:shoppinglistfschmtz/pages/new/new_shoplist.dart';
import '../../configs/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  const Home({Key key}) : super(key: key);
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> shopLists = [];
  int lastId;
  bool showItemCount;
  bool loading = true;

  @override
  void initState() {
    getShopLists();
    getLastId();
    super.initState();
    _loadFromPrefs();
  }

  _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showItemCount =  prefs.getBool('showItemCount') ?? true;
  }

  Future<void> getShopLists() async {
    final dbShopList = ShopListDao.instance;
    var resposta = await dbShopList.queryAllOrderByName();
    setState(() {
      shopLists = resposta;
      loading = false;
    });
  }

  Future<void> getLastId() async {
    final dbShopList = ShopListDao.instance;
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
        title: const Text('Shoplist'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add_outlined,
                size: 26,
                color: Theme.of(context)
                    .textTheme
                    .headline6
                    .color
                    .withOpacity(0.8),
              ),
              splashRadius: 28,
              tooltip: "New Shoplist",
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
              }),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
            child: IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Theme.of(context)
                      .textTheme
                      .headline6
                      .color
                      .withOpacity(0.8),
                ),
                splashRadius: 28,
                tooltip: "Settings",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => SettingsPage(),
                        fullscreenDialog: true,
                      )).then((value) => {
                      _loadFromPrefs(),
                      getShopLists()
                      }
                  );
                }),
          ),

        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: loading
            ? const Center(child: SizedBox.shrink())
            :
          ListView(children: <Widget>[
          ListView.separated(
                  separatorBuilder: (context, index) =>
                  const Divider(),
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: shopLists.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: ShopListHome(
                        refreshShopLists: getShopLists,
                        key: UniqueKey(),
                        showItemCount: showItemCount,
                        shopList: ShopList(
                          id: shopLists[index]['id'],
                          nome: shopLists[index]['nome'],
                          cor: shopLists[index]['cor'],
                        ),
                      ),
                    );
                  },
                ),
          const SizedBox(
            height: 100,
          ),
        ]),
      ),

    );
  }
}
