import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../service/item_service.dart';

class DialogNewItem extends StatefulWidget {
  @override
  State<DialogNewItem> createState() => _DialogNewItemState();

  const DialogNewItem({super.key, required this.idShopList});

  final int idShopList;
}

class _DialogNewItemState extends State<DialogNewItem> {
  TextEditingController controllerName = TextEditingController();
  bool _validName = true;

  Future<void> _insert() async {
    ItemService().insert(widget.idShopList, controllerName.text);
  }

  void _executeSaveItem() {
    if (_validateTextFields()) {
      _insert();
      Navigator.of(context).pop();
    } else {
      setState(() {
        _validName;
      });
    }
  }

  bool _validateTextFields() {
    if (controllerName.text.isEmpty) {
      _validName = false;
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Item'),
      content: SizedBox(
          width: 280.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: TextField(
                  autofocus: true,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controllerName,
                  decoration: InputDecoration(
                      labelText: "Name",
                      helperText: "* Required",
                      counterText: "",
                      border: const OutlineInputBorder(),
                      errorText: (_validName) ? null : "Name is empty"),
                ),
              ),
            ],
          )),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              _executeSaveItem();
            },
            child: const Text('Save'))
      ],
    );
  }
}
