import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';

class ItemEditShopList extends StatefulWidget {
  @override
  _ItemEditShopListState createState() => _ItemEditShopListState();

  Item item;
  Function() getItemsShopList;
  Function(int) deleteItem;
  Function(int, String, int) updateItem;
  Color listAccent;

  ItemEditShopList(
      {Key? key, required this.item, required this.getItemsShopList, required this.updateItem, required this.deleteItem, required this.listAccent})
      : super(key: key);
}

class _ItemEditShopListState extends State<ItemEditShopList> {
  bool value = false;
  bool showDelete = false;
  late FocusNode myFocusNode;
  TextEditingController customControllerNome = TextEditingController();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    customControllerNome.text = widget.item.nome;
  }

  void _updateEstadoItem(bool state) async {
    final dbShopList = ItemDao.instance;
    Map<String, dynamic> row = {
      ItemDao.columnId: widget.item.id,
      ItemDao.columnEstado: state ? 1 : 0,
    };
    final update = await dbShopList.update(row);
  }

  void controlFocus() {
    setState(() {
      showDelete = !showDelete;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) => controlFocus(),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Checkbox(
              splashRadius: 30,
              value: widget.item.estado == 0 ? false : true,
              onChanged: (bool? v) {
                setState(() {
                  _updateEstadoItem(v!);
                  widget.getItemsShopList();
                });
              },
            ),
            title: TextField(
              focusNode: myFocusNode,
              onChanged: (value) => widget.updateItem(widget.item.id, customControllerNome.text, widget.item.estado),
              minLines: 1,
              maxLines: 4,
              maxLength: 200,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              controller: customControllerNome,
              decoration: const InputDecoration(
                  hintText: "Item name",
                  border: InputBorder.none,
                  counterStyle: TextStyle(
                    height: double.minPositive,
                  ),
                  counterText: ""),
            ),
            trailing: IconButton(
                icon: const Icon(
                  Icons.clear,
                  size: 18,
                ),
                onPressed: () {
                  widget.deleteItem(widget.item.id);
                  widget.getItemsShopList();
                }),
          ),
        ),
      ),
    );
  }
}
