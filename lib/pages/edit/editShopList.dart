import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/db/shopListDao.dart';
import 'package:shoppinglistfschmtz/pages/edit/itemShopList.dart';
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
  List<Map<String, dynamic>> itemsDo = [];
  List<Map<String, dynamic>> itemsDone = [];

  String corAtual = "Color(0xFF607D8B)";

  @override
  void initState() {
    super.initState();
    getItemsShopList();

    customControllerNome.text = widget.shopList.nome;
    currentColor = Color(int.parse(widget.shopList.cor.substring(6, 16)));
    corAtual = widget.shopList.cor;
  }

  Future<void> getItemsShopList() async {
    final dbItems = itemDao.instance;
    var listDo = await dbItems.getItemsShopListDo(widget.shopList.id);
    var listDone = await dbItems.getItemsShopListDone(widget.shopList.id);

    //SetState error call, use if mounted
    if (mounted) {
      setState(() {
        //items = resposta;
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
      shopListDao.columnNome: customControllerNome.text.isEmpty ? "ShopList" : customControllerNome.text,
      shopListDao.columnCor: corAtual.toString(),
    };
    final update = await dbShopList.update(row);
  }

  Future<void> _deleteShopList() async {
    final dbShopList = shopListDao.instance;
    print("id deletado -> " + widget.shopList.id.toString());
    var resp = await dbShopList.delete(widget.shopList.id);
  }

  //DAO ITEMS
  void _addEmptyItemToShopList() async {
    final dbItems = itemDao.instance;
    Map<String, dynamic> row = {
      itemDao.columnNome: "",
      itemDao.columnEstado: 0,
      itemDao.columnIdShopList: widget.shopList.id,
    };
    final id = await dbItems.insert(row);
  }

  void _updateItem(int id,String nome,int estado) async {
    final dbItems = itemDao.instance;
    Map<String, dynamic> row = {
      itemDao.columnId: id,
      itemDao.columnNome: nome,
      itemDao.columnEstado: estado,
      //itemDao.columnIdShopList: widget.shopList.id,
    };
    final update = await dbItems.update(row);
  }


  //CHECK ERROR NULL
  String checkErrors() {
    String erros = "";
    if (customControllerNome.text.isEmpty) {
      erros += "Enter a name\n";
    }
    if (customControllerNome.text.length > 30) {
      erros += "Name too long\n";
    }
    return erros;
  }

  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text(
        "Yes",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  showAlertDialogErros(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: Text(
        "Error",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text(
        checkErrors(),
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

  createAlert(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: const Text(
          'Select Color :',
          style: TextStyle(fontSize: 18),
        ),
        content: SingleChildScrollView(
            child: BlockPicker(
          pickerColor: currentColor,
          onColorChanged: changeColor,
        )),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Ok',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onPressed: () {
              setState(() => {
                    currentColor = pickerColor,
                    corAtual = pickerColor.toString()
                  });
              _updateShopList();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 13, 0),//14
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
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLength: 30,
                      maxLengthEnforced: true,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.name,
                      controller: customControllerNome,
                      onChanged: (value) => _updateShopList(),
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: "Shopping List Name",
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 12.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(8.0)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(8.0))),
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  MaterialButton(
                    minWidth: 20,
                    height: 45,
                    child: Icon(
                      Icons.color_lens_rounded,
                      color: Colors.grey[800],
                      size: 24,
                    ),
                    shape: CircleBorder(),
                    elevation: 1,
                    color: currentColor,
                    onPressed: () {
                      createAlert(context);
                    },
                  ),
                ],
              ),
            ),

            //LIST
            const SizedBox(
              height: 50,
            ),
            ListView.separated(
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                      height: 12,
                    ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: itemsDo.length,
                itemBuilder: (context, index) {

                    return ItemEditShopList(
                      item: new Item(
                        id: itemsDo[index]['id'],
                        nome: itemsDo[index]['nome'],
                        estado: itemsDo[index]['estado'],
                        idShopList: itemsDo[index]['idShopList'],
                      ),
                      getItemsShopList: getItemsShopList,
                      key: UniqueKey(),
                      updateItem: _updateItem,
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
                  separatorBuilder: (BuildContext context, int index) => SizedBox(
                        height: 12,
                      ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemsDone.length,
                  itemBuilder: (context, index) {

                      return ItemEditShopList(
                        item: new Item(
                          id: itemsDone[index]['id'],
                          nome: itemsDone[index]['nome'],
                          estado: itemsDone[index]['estado'],
                          idShopList: itemsDone[index]['idShopList'],
                        ),
                        getItemsShopList: getItemsShopList,
                        key: UniqueKey(),
                        updateItem: _updateItem,
                      );

                  }),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            elevation: 6,
            onPressed: () {
              _addEmptyItemToShopList();
              getItemsShopList();
            },
            child: Icon(
              Icons.add_shopping_cart_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
