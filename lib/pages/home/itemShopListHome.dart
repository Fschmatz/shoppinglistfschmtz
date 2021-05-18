import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/db/itemDao.dart';

class ItemShopListHome extends StatefulWidget {
  @override
  _ItemShopListHomeState createState() => _ItemShopListHomeState();

  Item item;
  Function(int) getItemsRefreshShopList;

  ItemShopListHome({Key key, this.item,this.getItemsRefreshShopList})
      : super(key: key);
}

class _ItemShopListHomeState extends State<ItemShopListHome> {
  bool value = false;

  void _updateEstadoItem(bool state) async {
    final dbShopList = itemDao.instance;
    Map<String, dynamic> row = {
      itemDao.columnId: widget.item.id,
      itemDao.columnEstado: state ? 1:0,
    };
    final update = await dbShopList.update(row);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: ListTile(
        title: Text(
          widget.item.nome,
          style: TextStyle(fontSize: 16),
        ),
        trailing:  Checkbox(
          activeColor: Theme.of(context).accentColor,
          value: widget.item.estado == 1 ? true : false,
          onChanged: (bool v) {
            setState(() {
              _updateEstadoItem(v);
              widget.getItemsRefreshShopList(widget.item.idShopList);
            });
          },
        ),
      ),
    );
  }
}
