import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/db/shoplist_dao.dart';
import 'package:shoppinglistfschmtz/pages/home/shoplist_home.dart';
import 'package:shoppinglistfschmtz/pages/new/new_shoplist.dart';
import 'package:shoppinglistfschmtz/util/app_details.dart';
import '../../classes/item.dart';
import '../../configs/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/item_dao.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  const Home({Key? key}) : super(key: key);
}

class _HomeState extends State<Home> {
  List<ShopList> shopLists = [];
  late int lastId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    appStart();
  }

  Future<void> appStart() async {
    await getShopLists();
    await getLastId();
  }

  Future<void> getShopLists() async {
    final dbShopList = ShopListDao.instance;
    List<ShopList> shoplistsConvertedAndWithItems = [];
    var resposta = await dbShopList.queryAllOrderByName();

    if (resposta.isNotEmpty) {
      final dbItems = ItemDao.instance;
      shoplistsConvertedAndWithItems = resposta.map((map) => ShopList.fromMap(map)).toList();

      for (var shoplist in shoplistsConvertedAndWithItems) {
        List<Item> items = [];
        var respItems = await dbItems.getItemsShopListDoOrderName(shoplist.id);

        if (respItems.isNotEmpty) {
          items = respItems.map((map) => Item.fromMap(map)).toList();
        }

        shoplist.items = items;
      }
    }

    shopLists = shoplistsConvertedAndWithItems;

    setState(() {
      loading = false;
    });
  }

  Future<void> getLastId() async {
    final dbShopList = ShopListDao.instance;
    var resp = await dbShopList.getLastId();

    setState(() {
      if (resp.isEmpty) {
        lastId = 0;
      } else {
        lastId = resp[0]['id'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(AppDetails.appNameHomePage),
                pinned: false,
                floating: true,
                snap: true,
                actions: [
                  IconButton(
                      icon: const Icon(
                        Icons.add_outlined,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewShopList(
                                      lastId: lastId,
                                      refreshShopLists: getShopLists,
                                    ))).then((value) => getLastId());
                      }),
                  IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                      }),
                ],
              ),
            ];
          },
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: loading
                ? const Center(child: SizedBox.shrink())
                : ListView(children: <Widget>[
                    ListView.separated(
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(
                        height: 6,
                      ),
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: shopLists.length,
                      itemBuilder: (context, index) {
                        return ShopListHome(
                          key: UniqueKey(),
                          refreshShopLists: getShopLists,
                          shopList: shopLists[index],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ]),
          ),
        ),
      ),
    );
  }
}
