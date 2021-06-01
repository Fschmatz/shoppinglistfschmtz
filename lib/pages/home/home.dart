import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/db/shopListDao.dart';
import 'package:shoppinglistfschmtz/pages/home/shopListHome.dart';
import 'package:shoppinglistfschmtz/pages/new/newShopList.dart';
import '../../configs/settingsPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  Home({Key key}) : super(key: key);
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Map<String, dynamic>> shopLists = [];
  int lastId;
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    getShopLists();
    getLastId();
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  void resetController(){
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      appBar: AppBar(
        title: Text('ShopList'),
        elevation: 0,
      ),
      body: FadeTransition(
          opacity: _animation,
          child:
          ListView(children: <Widget>[
          ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: shopLists.length,
                  itemBuilder: (context, index) {
                    return ShopListHome(
                      refreshShopLists: getShopLists,
                      key: UniqueKey(),
                      resetController: resetController,
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
      ),

      bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    tooltip: "New Shopping List",
                    onPressed: () {
                      resetController();
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
                IconButton(
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
                      resetController();
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
