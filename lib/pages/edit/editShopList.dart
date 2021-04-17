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
            fontSize: 18,
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
            fontSize: 18,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              icon: Icon(
                Icons.delete_outline_outlined,
              ),
              onPressed: () {
                showAlertDialogOkDelete(context);
              },
            ),
          ),
        ],
        elevation: 0,
        title: Text('Edit Shopping List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLength: 30,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.name,
                          controller: customControllerNome,
                          onChanged: (value) => _updateShopList(),
                          decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              hintText: "Shopping List Name",
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 12.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700],
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[700],
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[700],
                                  ),
                                  borderRadius: BorderRadius.circular(8.0))),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      MaterialButton(
                        minWidth: 45,
                        height: 50,
                        shape: CircleBorder(),
                        elevation: 0,
                        color: currentColor,
                        onPressed: () {
                          createAlertSelectColor(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                            hintText: "  Add New Item",
                              filled: true,
                              prefixIcon: Icon(
                                Icons.add_shopping_cart_outlined,
                                color: currentColor.withOpacity(0.8),
                              ),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.8,
                                    color: currentColor,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.8,
                                    color: currentColor,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.8,
                                    color: currentColor,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              counterStyle: TextStyle(
                                height: double.minPositive,
                              ),
                              counterText: "" // hide maxlength counter
                              ),
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[800],
            ),
          ),

          //LIST
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(
                              height: 12,
                            ),
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
                    const SizedBox(
                      height: 30,
                    ),
                    Visibility(
                      visible: itemsDone.length > 0,
                      child: Divider(
                        thickness: 1.8,
                        indent: 6,
                        endIndent: 6,
                      ),
                    ),
                    Visibility(
                      visible: itemsDone.length > 0,
                      child: const SizedBox(
                        height: 30,
                      ),
                    ),
                    Visibility(
                      visible: itemsDone.length > 0,
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                                height: 12,
                              ),
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
          ),
        ],
      ),
    );
  }
}
