import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/db/shopListDao.dart';
import 'package:shoppinglistfschmtz/pages/edit/itemEditShopList.dart';
import '../../util/block_pickerAlt.dart';
import 'package:shoppinglistfschmtz/db/itemDao.dart';

class EditShopList extends StatefulWidget {
  @override
  _EditShopListState createState() => _EditShopListState();

  Function() refreshShopLists;
  ShopList shopList;

  EditShopList({Key key, this.refreshShopLists, this.shopList})
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
    final dbItems = itemDao.instance;
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
    final dbShopList = shopListDao.instance;
    Map<String, dynamic> row = {
      shopListDao.columnId: widget.shopList.id,
      shopListDao.columnNome: customControllerNome.text.isEmpty
          ? "ShopList"
          : customControllerNome.text,
      shopListDao.columnCor: corAtual.toString(),
    };
    final update = await dbShopList.update(row);
  }

  Future<void> _deleteShopList() async {
    final dbShopList = shopListDao.instance;
    print("id deletado -> " + widget.shopList.id.toString());
    var resp = await dbShopList.delete(widget.shopList.id);
  }

  void _deleteItem(int idItem) async {
    final dbItem = itemDao.instance;
    final deletado = await dbItem.delete(idItem);
  }

  //DAO ITEMS
  void _addItemToShopList() async {
    final dbItems = itemDao.instance;
    Map<String, dynamic> row = {
      itemDao.columnNome: customControllerAddNewItem.text,
      itemDao.columnEstado: 0,
      itemDao.columnIdShopList: widget.shopList.id,
    };
    final id = await dbItems.insert(row);
  }

  void _updateItem(int id, String nome, int estado) async {
    final dbItems = itemDao.instance;
    Map<String, dynamic> row = {
      itemDao.columnId: id,
      itemDao.columnNome: nome,
      itemDao.columnEstado: estado,
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
        widget.refreshShopLists();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: Text(
        "Confirmation ", //
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "\nDelete Shopping List ?",
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

  Color pickerColor = Color(0xFF607D8B);
  Color currentColor = Color(0xFF607D8B);

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
      title: Text(
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
          IconButton(
            icon: Icon(
              Icons.delete_outline_outlined,
            ),
            onPressed: () {
              showAlertDialogOkDelete(context);
            },
          ),
        ],
        elevation: 0,
        title: Text('Edit Shopping List'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.notes_outlined,
                ),
                title: TextField(
                  minLines: 1,
                  maxLength: 30,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.name,
                  controller: customControllerNome,
                  onChanged: (value) => _updateShopList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: "Shopping List Name",
                  ),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: MaterialButton(
                  minWidth: 30,
                  height: 30,
                  shape: CircleBorder(),
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
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
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
                      counterStyle: TextStyle(
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

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: itemsDo.length,
                      itemBuilder: (context, index) {
                        return ItemEditShopList(
                          key: UniqueKey(),
                          item: new Item(
                            id: itemsDo[index]['id'],
                            nome: itemsDo[index]['nome'],
                            estado: itemsDo[index]['estado'],
                            idShopList: itemsDo[index]['idShopList'],
                          ),
                          getItemsShopList: getItemsShopList,
                          updateItem: _updateItem,
                          deleteItem: _deleteItem,
                          listAccent: currentColor,
                        );
                      }),
                  Visibility(
                    visible: itemsDone.length > 0 && itemsDo.length > 0,
                    child: SizedBox(
                      height: 30,
                    ),
                  ),
                  Visibility(
                    visible: itemsDone.length > 0 && itemsDo.length > 0,
                    child: Divider(
                      thickness: 0.5,
                      indent: 6,
                      endIndent: 6,
                    ),
                  ),
                  Visibility(
                    visible: itemsDone.length > 0 && itemsDo.length > 0,
                    child: const SizedBox(
                      height: 30,
                    ),
                  ),
                  Visibility(
                    visible: itemsDone.length > 0,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: itemsDone.length,
                        itemBuilder: (context, index) {
                          return ItemEditShopList(
                            key: UniqueKey(),
                            item: new Item(
                              id: itemsDone[index]['id'],
                              nome: itemsDone[index]['nome'],
                              estado: itemsDone[index]['estado'],
                              idShopList: itemsDone[index]['idShopList'],
                            ),
                            getItemsShopList: getItemsShopList,
                            updateItem: _updateItem,
                            deleteItem: _deleteItem,
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
