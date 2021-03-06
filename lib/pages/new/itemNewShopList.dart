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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          width: 1,
          color: Colors.black.withOpacity(0.6),
        ),
      ),
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.clear,
                size: 18,
              ),
              onPressed: () {
                widget.deleteItem(widget.item.id);
              }),
          Expanded(
            child: TextField(
              onChanged:(value)=> widget.updateItem(widget.item.id,customControllerNome.text),
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
                      vertical: 18.0, horizontal: 10.0),
                  border: InputBorder.none,
                  counterStyle: TextStyle(
                    height: double.minPositive,
                  ),
                  counterText: "" // hide maxlength counter
              ),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
