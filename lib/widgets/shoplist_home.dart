import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/widgets/dialog_new_item.dart';
import 'package:shoppinglistfschmtz/widgets/item_shoplist_home.dart';

import '../service/shop_list_service.dart';
import 'dialog_store_shop_list.dart';

class ShopListHome extends StatefulWidget {
  @override
  State<ShopListHome> createState() => _ShopListHomeState();

  const ShopListHome({super.key, required this.shopList});

  final ShopList shopList;
}

class _ShopListHomeState extends State<ShopListHome> {
  List<Item> items = [];
  late Color shopListColor;
  final double _radius = 12;

  @override
  void initState() {
    super.initState();

    items = widget.shopList.items!;
    shopListColor = Color(int.parse(widget.shopList.color));
  }

  Future<void> _delete() async {
    ShopListService().delete(widget.shopList.id);
  }

  void _openDialogStoreShopList() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogStoreShopList(
            shopList: widget.shopList,
          );
        });
  }

  void _openDialogNewItem() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogNewItem(
            idShopList: widget.shopList.id,
          );
        });
  }

  void _openBottomMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    minVerticalPadding: 0,
                    title: Text(
                      widget.shopList.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text(
                      "Edit",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _openDialogStoreShopList();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_outlined),
                    title: const Text(
                      "Delete",
                    ),
                    onTap: () {
                      _delete();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final currentScheme = Theme.of(context).brightness == Brightness.light
        ? ColorScheme.fromSeed(seedColor: shopListColor)
        : ColorScheme.fromSeed(seedColor: shopListColor, brightness: Brightness.dark);

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
                  borderRadius: BorderRadius.circular(_radius),
                ),
                contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                onTap: () {},
                onLongPress: _openBottomMenu,
                title: Text(
                  widget.shopList.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: currentScheme.onPrimaryContainer,
                  ),
                ),
                trailing: IconButton.filledTonal(onPressed: _openDialogNewItem, icon: Icon(Icons.add_outlined)),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: ListView.separated(
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
                        border = RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(_radius), topRight: Radius.circular(_radius)),
                        );
                      } else if (isOnlyOneItem) {
                        border = RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_radius),
                        );
                      } else if (isLast) {
                        border = RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(_radius), bottomRight: Radius.circular(_radius)),
                        );
                      }

                      return ItemShopListHome(
                        key: UniqueKey(),
                        item: items[index],
                        colorScheme: currentScheme,
                        getItemsRefreshShopList: () => {},
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
