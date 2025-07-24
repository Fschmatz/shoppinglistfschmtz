import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/redux/selectors.dart';
import 'package:shoppinglistfschmtz/util/app_details.dart';
import 'package:shoppinglistfschmtz/widgets/shoplist_home.dart';

import '../../classes/shop_list.dart';
import '../../redux/app_state.dart';
import '../../widgets/dialog_store_shop_list.dart';
import '../settings/settings.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();

  const Home({super.key});
}

class _HomeState extends State<Home> {
  void _openDialogStoreShopList() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogStoreShopList();
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
                      _openDialogStoreShopList();
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
        body: StoreConnector<AppState, List<ShopList>>(
          converter: (store) {
            return selectShopLists();
          },
          builder: (context, shopLists) {
            return ListView(children: <Widget>[
              ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const SizedBox(
                  height: 4,
                ),
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: shopLists.length,
                itemBuilder: (context, index) {
                  return ShopListHome(
                    key: UniqueKey(),
                    shopList: shopLists[index],
                  );
                },
              ),
              const SizedBox(
                height: 50,
              ),
            ]);
          },
        ),
      ),
    ));
  }
}
