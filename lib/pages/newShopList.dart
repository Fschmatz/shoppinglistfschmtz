import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/db/shopListDao.dart';
import 'package:shoppinglistfschmtz/pages/list/containerItemEditShopList.dart';
import '../util/block_pickerAlterado.dart';
import 'package:shoppinglistfschmtz/db/itemDao.dart';

class NewShopList extends StatefulWidget {
  @override
  _NewShopListState createState() => _NewShopListState();

  Function() refreshShopLists;
  ShopList shopList;

  NewShopList({Key key, this.refreshShopLists, this.shopList})
      : super(key: key);
}

class _NewShopListState extends State<NewShopList> {
  TextEditingController customControllerNome = TextEditingController();
  TextEditingController customControllerCor = TextEditingController();
  List<Map<String, dynamic>> items = [];

  String corAtual = "Color(0xFF607D8B)";

  @override
  void initState() {
    super.initState();
    getItemsShopList();
  }

  Future<void> getItemsShopList() async {
    final dbItems = itemDao.instance;
    var resposta = await dbItems.getItemsShopList(widget.shopList.id);

    //SetState error call, use if mounted
    if (mounted) {
      setState(() {
        items = resposta;
      });
    }
  }

  //DAO SHOPLIST
  void _saveShopList() async {
    final dbShopList = shopListDao.instance;
    Map<String, dynamic> row = {
      shopListDao.columnNome: customControllerNome.text,
      shopListDao.columnCor: corAtual.toString(),
    };
    final id = await dbShopList.insert(row);
  }

  void _addEmptyItemToShopList() async {
    final dbItems = itemDao.instance;
    Map<String, dynamic> row = {
      itemDao.columnNome: "",
      itemDao.columnEstado: 0,
      itemDao.columnQuantity : 0,
      itemDao.columnIdShopList: widget.shopList.id,
    };
    final id = await dbItems.insert(row);
  }

  //CHECK ERROR NULL
  String checkErrors() {
    String erros = "";
    if (customControllerNome.text.isEmpty) {
      erros += "Enter a name\n";
    }
    if (customControllerNome.text.length > 200) {
      erros += "Name too long\n";
    }
    return erros;
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
            padding: const EdgeInsets.fromLTRB(0, 0, 13, 0),
            child: IconButton(
              icon: Icon(
                Icons.save_outlined,
              ),
              onPressed: () {
                if (checkErrors().isEmpty) {
                  _saveShopList();
                  widget.refreshShopLists();
                  Navigator.of(context).pop();
                } else {
                  showAlertDialogErros(context);
                }
              },
            ),
          )
        ],
        elevation: 0,
        title: Text('New Shopping List'),
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
            Row(
              children: [
                Expanded(
                  child: TextField(

                    minLines: 1,
                    maxLength: 25,
                    maxLengthEnforced: true,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.name,
                    controller: customControllerNome,
                    //autofocus: true,
                    decoration: InputDecoration(
                        fillColor: Theme.of(context).inputDecorationTheme.focusColor,
                        prefixIcon: Icon(Icons.view_list_outlined),
                        hintText: "Shopping List Name",
                        contentPadding:
                            new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(8.0)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(8.0))),
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 21),
                  child: MaterialButton(
                    minWidth: 20,
                    height: 47,
                    child:
                    Icon(Icons.color_lens_rounded),
                    shape: CircleBorder(),
                    elevation: 2,
                    color: currentColor,
                    onPressed: () {
                      createAlert(context);
                    },
                  ),
                ),
              ],
            ),

          //LIST TEST
            const SizedBox(height: 15,),
            Card(
              color: Theme.of(context).inputDecorationTheme.focusColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                side: BorderSide(
                  //color: Theme.of(context).inputDecorationTheme.focusedBorder.borderSide.color,
                  //width: 1.8,
                ),
              ),
              child: Column(
                children: [
                  ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                         SizedBox(height: 8,),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ContainerItemEditShopList(
                          item: new Item(
                            id: items[index]['id'],
                            nome: items[index]['nome'],
                            quantity: items[index]['quantity'],
                            estado: items[index]['estado'],
                            idShopList: items[index]['idShopList'],
                          ),
                        );

                      }),
                  const SizedBox(height: 15,),
                ],
              ),
            ),
            const SizedBox(height: 25,),

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
