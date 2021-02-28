import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/classes/shopList.dart';
import 'package:shoppinglistfschmtz/db/shopListDao.dart';
import 'package:shoppinglistfschmtz/pages/new/itemNewShopList.dart';
import '../../util/block_pickerAlt.dart';

class NewShopList extends StatefulWidget {
  @override
  _NewShopListState createState() => _NewShopListState();

  Function() refreshShopLists;
  ShopList shopList;
  int lastId;

  NewShopList({Key key, this.refreshShopLists, this.shopList,this.lastId})
      : super(key: key);
}

class _NewShopListState extends State<NewShopList> {
  TextEditingController customControllerNome = TextEditingController();
  TextEditingController customControllerCor = TextEditingController();
  //List<Map<String, Item>> itemsDo = [];
  //List<Map<String, Item>> itemsDone = [];

  List<Item> itemsDo = [];
  List<Item> itemsDone = [];

  String corAtual = "Color(0xFF607D8B)";

  @override
  void initState() {
    super.initState();
  }

  void refreshList(){
    setState(() {
    });
  }

  //DAO SHOPLIST
  void _saveShopList() async {
    Map<String, dynamic> row = {
      shopListDao.columnId: widget.lastId+1,
      shopListDao.columnNome: customControllerNome.text,
      shopListDao.columnCor: corAtual.toString(),
    };
  }

  void _addEmptyItemToShopList() async {
    itemsDo.insert(itemsDo.length,
        new Item(
      id: 55,
      nome: "",
      estado: 0,
      idShopList: widget.lastId+1)
    );
  }


/*
  //DAO SHOPLIST
  void _saveShopList() async {
    final dbShopList = shopListDao.instance;
    Map<String, dynamic> row = {
      shopListDao.columnId: widget.lastId+1,
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
      itemDao.columnIdShopList: widget.lastId+1,
    };
    final id = await dbItems.insert(row);
  }
*/

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
      body:SingleChildScrollView(
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
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: "Shopping List Name",
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 17.0, horizontal: 12.0),
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
                      size: 26,
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

                  return ItemNewShopList(
                    item: new Item(
                      id: itemsDo[index].id,
                      nome: itemsDo[index].nome,
                      estado: itemsDo[index].estado,
                      idShopList: itemsDo[index].idShopList,
                    ),
                    key: UniqueKey(),
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

                    return ItemNewShopList(
                      item: new Item(
                        id: itemsDone[index].id,
                        nome: itemsDone[index].nome,
                        estado: itemsDone[index].estado,
                        idShopList: itemsDone[index].idShopList,
                      ),
                      key: UniqueKey(),
                    );

                  }),
            ),
            const SizedBox(
              height: 25,
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
             refreshList();
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
