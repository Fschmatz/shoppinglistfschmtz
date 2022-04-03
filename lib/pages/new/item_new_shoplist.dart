import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';

class ItemNewShopList extends StatefulWidget {
  @override
  _ItemNewShopListState createState() => _ItemNewShopListState();

  Item item;
  Function(int, String) updateItem;
  Function(int) deleteItem;
  ItemNewShopList({Key key, this.item, this.updateItem,this.deleteItem}) : super(key: key);
}

class _ItemNewShopListState extends State<ItemNewShopList> {

  TextEditingController customControllerNome = TextEditingController();

  @override
  void initState() {
    super.initState();
    customControllerNome.text = widget.item.nome;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      leading: IconButton(
          icon: const Icon(
            Icons.clear,
            size: 18,
          ),
          onPressed: () {
            widget.deleteItem(widget.item.id);
          }),
      title: TextField(
        onChanged:(value)=> widget.updateItem(widget.item.id,customControllerNome.text),
        minLines: 1,
        maxLines: 4,
        maxLength: 200,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        textCapitalization: TextCapitalization.sentences,
        controller: customControllerNome,
        decoration: const InputDecoration(
            hintText: "Item Name",
            contentPadding: EdgeInsets.symmetric(
                vertical: 15.0, horizontal: 10.0),
            border: InputBorder.none,
            counterStyle: TextStyle(
              height: double.minPositive,
            ),
            counterText: "" // hide maxlength counter
        ),
      ),
    );

  }
}
