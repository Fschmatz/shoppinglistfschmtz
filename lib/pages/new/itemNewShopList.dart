import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/db/itemDao.dart';

class ItemNewShopList extends StatefulWidget {
  @override
  _ItemNewShopListState createState() => _ItemNewShopListState();

  Item item;


  ItemNewShopList({Key key, this.item}) : super(key: key);
}

class _ItemNewShopListState extends State<ItemNewShopList> {
  bool value = false;

  TextEditingController customControllerNome = TextEditingController();

  /*void _deletar() async {
    final dbItem = itemDao.instance;
    final deletado = await dbItem.delete(widget.item.id);
  }

  void _updateEstadoItem(bool state) async {
    final dbShopList = itemDao.instance;
    Map<String, dynamic> row = {
      itemDao.columnId: widget.item.id,
      itemDao.columnEstado: state ? 1:0,
    };
    final update = await dbShopList.update(row);
  }*/

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
              ? Colors.black.withOpacity(0.6)
              : Colors.black.withOpacity(0.3),
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
                //_deletar();
                //widget.getItemsShopList();
              }),
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: customControllerNome,
              decoration: InputDecoration(
                  hintText: "Item Name",
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 10.0),
                  border: InputBorder.none,
                  counterStyle: TextStyle(
                    height: double.minPositive,
                  ),
                  counterText: "" // hide maxlength counter
                  ),
              style: TextStyle(
                fontSize: 18,
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
            activeColor: Theme.of(context).accentColor.withOpacity(0.6),
            value: widget.item.estado == 0 ? false : true,
            onChanged: (bool v) {
              setState(() {
                //value = v;
                //_updateEstadoItem(v);
                //widget.getItemsShopList();
              });
            },
          ),
        ],
      ),
    );
  }
}
