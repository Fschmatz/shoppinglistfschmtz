import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/db/shoplist_dao.dart';
import 'package:shoppinglistfschmtz/pages/edit/item_edit_shoplist.dart';
import '../../util/block_picker_alt.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';
import '../../util/utils_functions.dart';

class EditShopList extends StatefulWidget {
  @override
  _EditShopListState createState() => _EditShopListState();

  ShopList shopList;

  EditShopList({Key? key, required this.shopList}) : super(key: key);
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
    var listDo = await dbItems.getItemsShopListDoOrderName(widget.shopList.id);
    var listDone = await dbItems.getItemsShopListDoneOrderName(widget.shopList.id);

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
      ShopListDao.columnNome: controllerNomeShoplist.text.isEmpty ? "Shoplist" : controllerNomeShoplist.text,
      ShopListDao.columnCor: corAtual.toString(),
    };

    await dbShopList.update(row);
  }

  Future<void> _deleteShopList() async {
    final dbShopList = ShopListDao.instance;
    await dbShopList.delete(widget.shopList.id);
  }

  void _deleteItemFromShoplist(int idItem) async {
    final dbItem = ItemDao.instance;
    await dbItem.delete(idItem);
  }

  //DAO ITEMS
  void _addItemToShopList() async {
    final dbItems = ItemDao.instance;
    Map<String, dynamic> row = {
      ItemDao.columnNome: controllerAddNewItem.text,
      ItemDao.columnEstado: 0,
      ItemDao.columnIdShopList: widget.shopList.id,
    };

    await dbItems.insert(row);
  }

  void _updateItem(int id, String nome, int estado) async {
    final dbItems = ItemDao.instance;
    Map<String, dynamic> row = {
      ItemDao.columnId: id,
      ItemDao.columnNome: nome,
      ItemDao.columnEstado: estado,
    };

    await dbItems.update(row);
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.grey.shade800,
                ),
              ),
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
        setState(() {
          currentColor = pickerColor;
          corAtual = pickerColor.toString();
        });
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

  @override
  Widget build(BuildContext context) {
    final currentScheme = Theme.of(context).brightness == Brightness.light
        ? ColorScheme.fromSeed(seedColor: currentColor)
        : ColorScheme.fromSeed(seedColor: currentColor, brightness: Brightness.dark);

    return Theme(
      data: ThemeData(
        colorScheme: currentScheme,
        useMaterial3: true,
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Theme(
                data: Theme.of(context).copyWith(useMaterial3: false),
                child: PopupMenuButton<int>(
                    icon: const Icon(Icons.more_vert_outlined),
                    itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                          const PopupMenuItem<int>(value: 0, child: Text('Rename')),
                          const PopupMenuItem<int>(value: 1, child: Text('Change color')),
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
                    }),
              )
            ],
            title: Text(controllerNomeShoplist.text),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextField(
                  minLines: 1,
                  maxLength: 200,
                  autofocus: false,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controllerAddNewItem,
                  onSubmitted: (value) => {
                    if (controllerAddNewItem.text.isNotEmpty) {_addItemToShopList(), getItemsShopList(), controllerAddNewItem.text = ""}
                  },
                  onEditingComplete: () {},
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.add_outlined),
                      hintText: "New item",
                      counterStyle: TextStyle(
                        height: double.minPositive,
                      ),
                      counterText: ""),
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
      ),
    );
  }
}
