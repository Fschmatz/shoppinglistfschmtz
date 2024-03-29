import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';

class ItemNewShopList extends StatefulWidget {
  @override
  _ItemNewShopListState createState() => _ItemNewShopListState();

  Item item;
  Function(int, String) updateItem;
  Function(int) deleteItem;

  ItemNewShopList({Key key, this.item, this.updateItem, this.deleteItem})
      : super(key: key);
}

class _ItemNewShopListState extends State<ItemNewShopList> {
  FocusNode myFocusNode;
  bool showDelete = false;
  TextEditingController customControllerNome = TextEditingController();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    customControllerNome.text = widget.item.nome;
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
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        title: TextField(
          focusNode: myFocusNode,
          onChanged: (value) =>
              widget.updateItem(widget.item.id, customControllerNome.text),
          minLines: 1,
          maxLines: 4,
          maxLength: 200,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          textCapitalization: TextCapitalization.sentences,
          controller: customControllerNome,
          decoration: const InputDecoration(
              hintText: "Item name",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: InputBorder.none,
              counterStyle: TextStyle(
                height: double.minPositive,
              ),
              counterText: "" // hide maxlength counter
              ),
        ),
        trailing: myFocusNode.hasFocus //showDelete
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  size: 18,
                ),
                onPressed: () {
                  widget.deleteItem(widget.item.id);
                })
            : null,
      ),
    ));
  }
}
