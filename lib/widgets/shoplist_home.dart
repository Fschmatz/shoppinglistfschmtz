import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/widgets/item_shoplist_home.dart';

import '../service/item_service.dart';
import '../service/shop_list_service.dart';
import 'dialog_store_shop_list.dart';

class ShopListHome extends StatefulWidget {
  @override
  State<ShopListHome> createState() => _ShopListHomeState();

  const ShopListHome({super.key, required this.shopList});

  final ShopList shopList;
}

class _ShopListHomeState extends State<ShopListHome> {
  List<Item> _items = [];
  late Color _shopListColor;
  final double _radius = 16;
  final TextEditingController _controllerName = TextEditingController();
  FocusNode _itemNameFocusNode = FocusNode();
  bool _isUpdateItem = false;
  late Item _itemForUpdate;

  @override
  void initState() {
    super.initState();

    _itemNameFocusNode = FocusNode();
    _items = widget.shopList.items!;
    _shopListColor = Color(int.parse(widget.shopList.color));
  }

  Future<void> _deleteShopList() async {
    ShopListService().delete(widget.shopList.id);
  }

  Future<void> _storeItem() async {
    if (_isUpdateItem) {
      _updateItem();
      Navigator.of(context).pop();
    } else {
      _insertItem();
    }
  }

  Future<void> _insertItem() async {
    ItemService().insert(widget.shopList.id, _controllerName.text);
  }

  Future<void> _updateItem() async {
    ItemService().update(_itemForUpdate, _controllerName.text);
  }

  void _executeSaveItem() {
    if (_controllerName.text.isNotEmpty) {
      _storeItem();
      _controllerName.clear();
      _itemNameFocusNode.requestFocus();
      _isUpdateItem = false;
    }
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

  void _openShopListBottomMenu() {
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
                      _deleteShopList();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openBottomMenuEditItem(Item item) {
    _isUpdateItem = true;
    _itemForUpdate = item;
    _controllerName.text = item.name;

    _openBottomMenuItem();
  }

  void _openBottomMenuAddItem() {
    _controllerName.clear();
    _openBottomMenuItem();
  }

  void _openBottomMenuItem() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    minVerticalPadding: 0,
                    title: Text(
                      '${widget.shopList.name}${_isUpdateItem ? '' : ' - new item'}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: TextField(
                      focusNode: _itemNameFocusNode,
                      autofocus: true,
                      maxLength: 50,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _controllerName,
                      onSubmitted: (_) => _executeSaveItem(),
                      decoration: InputDecoration(labelText: "Name", helperText: "* Required", counterText: "", border: const OutlineInputBorder()),
                    ),
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
        ? ColorScheme.fromSeed(seedColor: _shopListColor)
        : ColorScheme.fromSeed(seedColor: _shopListColor, brightness: Brightness.dark);

    return Theme(
      data: ThemeData(
        colorScheme: currentScheme,
        useMaterial3: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          color: currentScheme.surfaceContainerHigh,
          child: Column(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_radius),
                ),
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                onTap: () {},
                onLongPress: _openShopListBottomMenu,
                title: Text(
                  widget.shopList.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: currentScheme.onPrimaryContainer,
                  ),
                ),
                trailing: IconButton.filledTonal(
                  onPressed: _openBottomMenuAddItem,
                  icon: Icon(Icons.add_outlined),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(
                          height: 2,
                        ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      bool isFirst = index == 0 && _items.length > 1;
                      bool isLast = index == _items.length - 1;
                      bool isOnlyOneItem = _items.length == 1;

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
                        item: _items[index],
                        colorScheme: currentScheme,
                        getItemsRefreshShopList: () => {},
                        cardBorderRadius: border,
                        onEditItem: openBottomMenuEditItem,
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
