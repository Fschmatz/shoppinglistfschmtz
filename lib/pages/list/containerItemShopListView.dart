import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';

class ContainerItemShopListView extends StatefulWidget {
  @override
  _ContainerItemShopListViewState createState() => _ContainerItemShopListViewState();

  Item item;

  ContainerItemShopListView({Key key, this.item})
      : super(key: key);
}

class _ContainerItemShopListViewState extends State<ContainerItemShopListView> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: ListTile(
        leading: Text(
          widget.item.quantity.toString(),
          style: TextStyle(fontSize: 17,),
          textAlign: TextAlign.center,
        ),
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
