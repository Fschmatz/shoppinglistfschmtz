import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/service/item_service.dart';

class ItemShopListHome extends StatefulWidget {
  @override
  State<ItemShopListHome> createState() => _ItemShopListHomeState();

  const ItemShopListHome(
      {super.key, required this.item, required this.getItemsRefreshShopList, required this.colorScheme, required this.cardBorderRadius});

  final Item item;
  final Function() getItemsRefreshShopList;
  final ColorScheme colorScheme;
  final RoundedRectangleBorder cardBorderRadius;
}

class _ItemShopListHomeState extends State<ItemShopListHome> {
  void _delete() async {
    ItemService().delete(widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: widget.colorScheme.primaryContainer,
      shape: widget.cardBorderRadius,
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
      title: Text(
        widget.item.name,
        style: TextStyle(color: widget.colorScheme.onPrimaryContainer),
      ),
      trailing: IconButton.filledTonal(
        onPressed: _delete,
        icon: Icon(Icons.check_outlined),
        color: widget.colorScheme.onPrimaryContainer,
        highlightColor: Colors.red,
        style: IconButton.styleFrom(backgroundColor: widget.colorScheme.surfaceContainer),
      ),
    );
  }
}
