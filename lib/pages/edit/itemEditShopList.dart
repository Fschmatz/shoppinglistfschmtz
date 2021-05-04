import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/db/itemDao.dart';

class ItemEditShopList extends StatefulWidget {
  @override
  _ItemEditShopListState createState() => _ItemEditShopListState();

  Item item;
  Function() getItemsShopList;
  Function(int) deleteItem;
  Function(int, String, int) updateItem;
  Color listAccent;

  ItemEditShopList({Key key, this.item, this.getItemsShopList, this.updateItem,this.deleteItem,this.listAccent})
      : super(key: key);
}

class _ItemEditShopListState extends State<ItemEditShopList> {
  bool value = false;

  TextEditingController customControllerNome = TextEditingController();


  void _updateEstadoItem(bool state) async {
    final dbShopList = itemDao.instance;
    Map<String, dynamic> row = {
      itemDao.columnId: widget.item.id,
      itemDao.columnEstado: state ? 1 : 0,
    };
    final update = await dbShopList.update(row);
  }

  @override
  void initState() {
    super.initState();
    customControllerNome.text = widget.item.nome;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          width: 1,
          color: widget.item.estado == 0
              ? Colors.grey[800]
              : Colors.grey[800].withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.clear,
                size: 18,
                color: widget.item.estado == 1
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).textTheme.headline6.color,
              ),
              onPressed: () {
                widget.deleteItem(widget.item.id);
                widget.getItemsShopList();
              }),
          Expanded(
            child: TextField(
              onChanged: (value) => widget.updateItem(widget.item.id,
                  customControllerNome.text, widget.item.estado),
              minLines: 1,
              maxLines: 4,
              maxLength: 200,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: customControllerNome,
              decoration: InputDecoration(
                  hintText: "Item Name",
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  border: InputBorder.none,
                  counterStyle: TextStyle(
                    height: double.minPositive,
                  ),
                  counterText: "" // hide maxlength counter
              ),
              style: TextStyle(
                fontSize: 16,
                color: widget.item.estado == 1
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Checkbox(
            //activeColor: Theme.of(context).accentColor.withOpacity(0.6),
            activeColor: widget.listAccent.withOpacity(0.4),
            value: widget.item.estado == 0 ? false : true,
            onChanged: (bool v) {
              setState(() {
                _updateEstadoItem(v);
                widget.getItemsShopList();
              });
            },
          ),
        ],
      ),
    );
  }
}

