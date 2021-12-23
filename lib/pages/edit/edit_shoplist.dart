import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shop_list.dart';
import 'package:shoppinglistfschmtz/db/shoplist_dao.dart';
import 'package:shoppinglistfschmtz/pages/edit/item_edit_shoplist.dart';
import '../../util/block_pickerAlt.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';

class EditShopList extends StatefulWidget {
  @override
  _EditShopListState createState() => _EditShopListState();

  ShopList shopList;

  EditShopList({Key key, this.shopList})
      : super(key: key);
}

class _EditShopListState extends State<EditShopList> {
  TextEditingController customControllerNome = TextEditingController();
  TextEditingController customControllerCor = TextEditingController();
  TextEditingController customControllerAddNewItem = TextEditingController();
  List<Map<String, dynamic>> itemsDo = [];
  List<Map<String, dynamic>> itemsDone = [];
  String corAtual = "Color(0xFF607D8B)";

  @override
  void initState() {
    super.initState();
    getItemsShopList();

    customControllerNome.text = widget.shopList.nome;
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
      ShopListDao.columnNome: customControllerNome.text.isEmpty
          ? "Shoplist"
          : customControllerNome.text,
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
      ItemDao.columnNome: customControllerAddNewItem.text,
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
    Widget okButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headline6.color),
      ),
      onPressed: () {
        _deleteShopList();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: const Text(
        "Confirmation ", //
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "\nDelete Shoplist ?",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
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

  Color pickerColor = const Color(0xFF607D8B);
  Color currentColor = const Color(0xFF607D8B);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  createAlertSelectColor(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Ok",
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headline6.color),
      ),
      onPressed: () {
        setState(() =>
            {currentColor = pickerColor, corAtual = pickerColor.toString()});
        _updateShopList();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: const Text(
        "Select Color : ", //
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            child: IconButton(
              icon: const Icon(
                Icons.delete_outline_outlined,
              ),
              onPressed: () {
                showAlertDialogOkDelete(context);
              },
            ),
          ),
        ],
        title: const Text('Edit Shoplist'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
                leading: const Icon(
                  Icons.notes_outlined,
                ),
                title: TextField(
                  minLines: 1,
                  maxLength: 30,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  controller: customControllerNome,
                  onChanged: (value) => _updateShopList(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: "Shoplist Name",
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: MaterialButton(
                  minWidth: 30,
                  height: 30,
                  shape: const CircleBorder(),
                  elevation: 0,
                  color: currentColor,
                  onPressed: () {
                    createAlertSelectColor(context);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(
                  Icons.add_shopping_cart_outlined,
                  color: currentColor.withOpacity(0.8),
                ),
                title: TextField(
                  minLines: 1,
                  maxLength: 200,
                  autofocus: false,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  controller: customControllerAddNewItem,
                  onSubmitted: (value) => {
                    _addItemToShopList(),
                    getItemsShopList(),
                    customControllerAddNewItem.text = ""
                  },
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                      hintText: "Add New Item",
                      hintStyle: TextStyle(color: currentColor.withOpacity(0.8)),
                      border: InputBorder.none,
                      counterStyle: const TextStyle(
                        height: double.minPositive,
                      ),
                      counterText: "" // hide maxlength counter
                      ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Divider(
              height: 1,
            ),
          ),

          //LIST
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
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
                      height: 30,
                    ),
                  ),
                  Visibility(
                    visible: itemsDone.isNotEmpty && itemsDo.isNotEmpty,
                    child: const Divider(
                      thickness: 0.5,
                      indent: 6,
                      endIndent: 6,
                    ),
                  ),
                  Visibility(
                    visible: itemsDone.isNotEmpty && itemsDo.isNotEmpty,
                    child: const SizedBox(
                      height: 30,
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
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
