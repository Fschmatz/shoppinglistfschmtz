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
  final TextEditingController _controllerName = TextEditingController();
  bool _validName = true;
  Color _pickerColor = const Color(0xFF8a63c6);
  Color _selectedColor = const Color(0xFF8a63c6);
  bool _isUpdate = true;

  @override
  void initState() {
    super.initState();

    _isUpdate = widget.shopList != null;

    if (_isUpdate) {
      _pickerColor = Color(int.parse(widget.shopList!.color));
      _selectedColor = Color(int.parse(widget.shopList!.color));
      _controllerName.text = widget.shopList!.name;
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
    ShopListService().insert(_controllerName.text, _selectedColor);
  }

  Future<void> _update() async {
    ShopListService().update(widget.shopList!.id, _controllerName.text, _selectedColor);
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
    if (_controllerName.text.isEmpty) {
      _validName = false;
      return false;
    }

    return true;
  }

  void changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Shop List'),
      content: SizedBox(
          // width: 300,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: !_isUpdate,
            maxLength: 50,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            textCapitalization: TextCapitalization.sentences,
            controller: _controllerName,
            decoration: InputDecoration(
              labelText: "Name",
              helperText: "* Required",
              counterText: "",
              border: const OutlineInputBorder(),
              errorText: (_validName) ? null : "Name is empty",
            ),
          ),
          SizedBox(
            height: 5,
          ),
          BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: changeColor,
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
