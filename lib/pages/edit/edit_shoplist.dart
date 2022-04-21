import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/db/shoplist_dao.dart';
import 'package:shoppinglistfschmtz/pages/edit/item_edit_shoplist.dart';
import '../../util/block_pickerAlt.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';

import '../../util/utils_functions.dart';

class EditShopList extends StatefulWidget {
  @override
  _EditShopListState createState() => _EditShopListState();

  ShopList shopList;

  EditShopList({Key key, this.shopList}) : super(key: key);
}

class _EditShopListState extends State<EditShopList> {
  TextEditingController controllerNomeShoplist = TextEditingController();
  TextEditingController controllerCor = TextEditingController();
  TextEditingController controllerAddNewItem = TextEditingController();
  List<Map<String, dynamic>> itemsDo = [];
  List<Map<String, dynamic>> itemsDone = [];
  String corAtual = "Color(0xFF607D8B)";

  @override
  void initState() {
    super.initState();
    getItemsShopList();

    controllerNomeShoplist.text = widget.shopList.nome;
    corAtual = widget.shopList.cor;
    currentColor = Color(int.parse(widget.shopList.cor.substring(6, 16)));
    pickerColor = Color(int.parse(widget.shopList.cor.substring(6, 16)));
  }

  Future<void> getItemsShopList() async {
    final dbItems = ItemDao.instance;
    var listDo = await dbItems.getItemsShopListDoDesc(widget.shopList.id);
    var listDone = await dbItems.getItemsShopListDoneDesc(widget.shopList.id);

    //SetState error call, use if mounted
    if (mounted) {
      setState(() {
        itemsDo = listDo;
        itemsDone = listDone;
      });
    }
  }

  //DAO SHOPLIST
  void _updateShopList() async {
    final dbShopList = ShopListDao.instance;
    Map<String, dynamic> row = {
      ShopListDao.columnId: widget.shopList.id,
      ShopListDao.columnNome: controllerNomeShoplist.text.isEmpty
          ? "Shoplist"
          : controllerNomeShoplist.text,
      ShopListDao.columnCor: corAtual.toString(),
    };
    final update = await dbShopList.update(row);
  }

  Future<void> _deleteShopList() async {
    final dbShopList = ShopListDao.instance;
    var resp = await dbShopList.delete(widget.shopList.id);
  }

  void _deleteItemFromShoplist(int idItem) async {
    final dbItem = ItemDao.instance;
    final deletado = await dbItem.delete(idItem);
  }

  //DAO ITEMS
  void _addItemToShopList() async {
    final dbItems = ItemDao.instance;
    Map<String, dynamic> row = {
      ItemDao.columnNome: controllerAddNewItem.text,
      ItemDao.columnEstado: 0,
      ItemDao.columnIdShopList: widget.shopList.id,
    };
    final id = await dbItems.insert(row);
  }

  void _updateItem(int id, String nome, int estado) async {
    final dbItems = ItemDao.instance;
    Map<String, dynamic> row = {
      ItemDao.columnId: id,
      ItemDao.columnNome: nome,
      ItemDao.columnEstado: estado,
    };
    final update = await dbItems.update(row);
  }

  showAlertDialogOkDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Confirmation",
            ),
            content: const Text(
              "Delete shoplist ?",
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Yes",
                ),
                onPressed: () {
                  _deleteShopList();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
  }

  showDialogRename(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Rename shoplist",
            ),
            content: Card(
              elevation: 0,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                title: TextField(
                  autofocus: true,
                  minLines: 1,
                  maxLength: 30,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controllerNomeShoplist,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: "Shoplist name",
                  ),
                  onSubmitted: (value) => renameShoplistFunction(),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Ok",
                ),
                onPressed: () {
                  renameShoplistFunction();
                },
              )
            ]);
      },
    );
  }

  void renameShoplistFunction() {
    _updateShopList();
    setState(() {
      controllerNomeShoplist;
    });
    Navigator.of(context).pop();
  }

  Color pickerColor = const Color(0xFF607D8B);
  Color currentColor = const Color(0xFF607D8B);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  dialogSelectColor(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text(
        "Ok",
      ),
      onPressed: () {
        setState(() =>
            {currentColor = pickerColor, corAtual = pickerColor.toString()});
        _updateShopList();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "Select color :",
      ),
      content: SingleChildScrollView(
          child: BlockPicker(
        pickerColor: currentColor,
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

  void loseFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness _addNewItemTextBrightness = Theme.of(context).brightness;
    Color shoplistAccent = _addNewItemTextBrightness == Brightness.dark
        ? lightenColor(currentColor, 20)
        : darkenColor(currentColor, 20);

    return GestureDetector(
      onTap: () {
        loseFocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert_outlined),
                itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      const PopupMenuItem<int>(value: 0, child: Text('Rename')),
                      const PopupMenuItem<int>(
                          value: 1, child: Text('Change color')),
                      const PopupMenuItem<int>(value: 2, child: Text('Delete')),
                    ],
                onSelected: (int value) {
                  if (value == 0) {
                    showDialogRename(context);
                  } else if (value == 1) {
                    dialogSelectColor(context);
                  } else if (value == 2) {
                    showAlertDialogOkDelete(context);
                  }
                })
          ],
          title: Text(controllerNomeShoplist.text),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Card(
                child: TextField(
                  minLines: 1,
                  maxLength: 200,
                  autofocus: false,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controllerAddNewItem,
                  onSubmitted: (value) => {
                    _addItemToShopList(),
                    getItemsShopList(),
                    controllerAddNewItem.text = ""
                  },
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardTheme.color,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).cardTheme.color,
                          ),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: shoplistAccent,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: Icon(
                        Icons.add_shopping_cart_outlined,
                        color: shoplistAccent,
                      ),
                      hintText: "Add new item",
                      hintStyle: TextStyle(
                        color: shoplistAccent.withOpacity(0.5),
                      ),
                      counterStyle: const TextStyle(
                        height: double.minPositive,
                      ),
                      counterText: "" // hide maxlength counter
                      ),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
              ),
            ),

            //LIST
            Flexible(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: itemsDo.length,
                      itemBuilder: (context, index) {
                        return ItemEditShopList(
                          key: UniqueKey(),
                          item: Item(
                            id: itemsDo[index]['id'],
                            nome: itemsDo[index]['nome'],
                            estado: itemsDo[index]['estado'],
                            idShopList: itemsDo[index]['idShopList'],
                          ),
                          getItemsShopList: getItemsShopList,
                          updateItem: _updateItem,
                          deleteItem: _deleteItemFromShoplist,
                          listAccent: currentColor,
                        );
                      }),
                  Visibility(
                    visible: itemsDone.isNotEmpty && itemsDo.isNotEmpty,
                    child: const SizedBox(
                      height: 15,
                    ),
                  ),
                  Visibility(
                    visible: itemsDone.isNotEmpty && itemsDo.isNotEmpty,
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: itemsDone.isNotEmpty && itemsDo.isNotEmpty,
                    child: const SizedBox(
                      height: 15,
                    ),
                  ),
                  Visibility(
                    visible: itemsDone.isNotEmpty,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: itemsDone.length,
                        itemBuilder: (context, index) {
                          return ItemEditShopList(
                            key: UniqueKey(),
                            item: Item(
                              id: itemsDone[index]['id'],
                              nome: itemsDone[index]['nome'],
                              estado: itemsDone[index]['estado'],
                              idShopList: itemsDone[index]['idShopList'],
                            ),
                            getItemsShopList: getItemsShopList,
                            updateItem: _updateItem,
                            deleteItem: _deleteItemFromShoplist,
                            listAccent: currentColor,
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
