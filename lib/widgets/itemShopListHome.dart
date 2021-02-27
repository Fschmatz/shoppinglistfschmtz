import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';

class ItemShopListHome extends StatefulWidget {
  @override
  _ItemShopListHomeState createState() => _ItemShopListHomeState();

  Item item;

  ItemShopListHome({Key key, this.item})
      : super(key: key);
}

class _ItemShopListHomeState extends State<ItemShopListHome> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: ListTile(
        title: Text(
          widget.item.nome,
          style: TextStyle(fontSize: 17),
        ),
        trailing:  Checkbox(
          activeColor: Theme.of(context).accentColor,
          value: value, //widget.item.estado == 0 ? false : true,
          onChanged: (bool v) {
            setState(() {
              value = v;
            });
          },
        ),
      ),
    );
  }
}
