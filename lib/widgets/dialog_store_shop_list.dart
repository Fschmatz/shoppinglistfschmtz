import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/service/shop_list_service.dart';

import '../classes/shop_list.dart';
import '../util/block_picker_alt.dart';

class DialogStoreShopList extends StatefulWidget {
  @override
  State<DialogStoreShopList> createState() => _DialogStoreShopListState();

  const DialogStoreShopList({super.key, this.shopList});

  final ShopList? shopList;
}

class _DialogStoreShopListState extends State<DialogStoreShopList> {
  TextEditingController controllerName = TextEditingController();
  bool _validName = true;
  Color pickerColor = const Color(0xFFFF5252);
  Color selectedColor = const Color(0xFFFF5252);
  bool _isUpdate = true;

  @override
  void initState() {
    super.initState();

    _isUpdate = widget.shopList != null;

    if (_isUpdate) {
      pickerColor = Color(int.parse(widget.shopList!.color));
      selectedColor = Color(int.parse(widget.shopList!.color));
      controllerName.text = widget.shopList!.name;
    }
  }

  Future<void> _store() async {
    if (_isUpdate) {
      _update();
    } else {
      _insert();
    }
  }

  Future<void> _insert() async {
    ShopListService().insert(controllerName.text, selectedColor);
  }

  Future<void> _update() async {
    ShopListService().update(widget.shopList!.id, controllerName.text, selectedColor);
  }

  void _executeSaveShopList() {
    if (_validateTextFields()) {
      _store();
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

  void _openDialogSelectColor(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text(
        "Ok",
      ),
      onPressed: () {
        setState(() {
          selectedColor = pickerColor;
          //currentColorAsString = pickerColor.toString();
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Select Color : "),
      content: SingleChildScrollView(
          child: BlockPicker(
        pickerColor: selectedColor,
        onColorChanged: changeColor,
      )),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Shop List'),
      content: SizedBox(
          width: 300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controllerName,
                  decoration: InputDecoration(
                    labelText: "Name",
                    helperText: "* Required",
                    counterText: "",
                    border: const OutlineInputBorder(),
                    errorText: (_validName) ? null : "Name is empty",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                child: MaterialButton(
                  minWidth: 30,
                  height: 50,
                  shape: const CircleBorder(),
                  elevation: 0,
                  color: selectedColor,
                  onPressed: () {
                    _openDialogSelectColor(context);
                  },
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
              _executeSaveShopList();
            },
            child: const Text('Save'))
      ],
    );
  }
}
