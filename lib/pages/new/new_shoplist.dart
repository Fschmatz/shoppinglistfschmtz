import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/db/shoplist_dao.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';
import 'package:shoppinglistfschmtz/pages/new/item_new_shoplist.dart';
import '../../util/block_pickerAlt.dart';
import '../../util/utils_functions.dart';

class NewShopList extends StatefulWidget {
  @override
  _NewShopListState createState() => _NewShopListState();

  int lastId;
  Function() refreshShopLists;

  NewShopList({Key key, this.lastId, this.refreshShopLists}) : super(key: key);
}

class _NewShopListState extends State<NewShopList> {
  TextEditingController customControllerNome = TextEditingController();
  TextEditingController customControllerCor = TextEditingController();
  TextEditingController customControllerAddNewItem = TextEditingController();
  bool editingItem = false;
  List<Item> items = [];

  String corAtual = "Color(0xFFFF5252)";

  @override
  void initState() {
    super.initState();
  }

  void refreshList() {
    setState(() {});
  }

  void isEditingItem() {
    setState(() {
      editingItem = !editingItem;
    });
  }

  void updateItem(int idItem, String nome) {
    items[idItem].nome = nome;
  }

  void _deleteItem(int idItem) async {
    setState(() {
      items.removeAt(idItem);
    });
  }

  void _addItemToShopList() async {
    items.insert(
        items.length,
        Item(
            id: items.length,
            nome: customControllerAddNewItem.text,
            estado: 0,
            idShopList: widget.lastId + 1));
  }

  //DAO SHOPLIST
  Future<void> _saveShopList() async {
    final dbShopList = ShopListDao.instance;
    Map<String, dynamic> row = {
      ShopListDao.columnId: widget.lastId + 1,
      ShopListDao.columnNome: customControllerNome.text.isEmpty
          ? "Shoplist"
          : customControllerNome.text,
      ShopListDao.columnCor: corAtual.toString(),
    };
    final id = await dbShopList.insert(row);
  }

  Future<void> _saveItemsToShopList() async {
    final dbItems = ItemDao.instance;
    for (int i = 0; i < items.length; i++) {
      Map<String, dynamic> row = {
        ItemDao.columnNome: items[i].nome,
        ItemDao.columnEstado: 0,
        ItemDao.columnIdShopList: widget.lastId + 1,
      };
      final id = await dbItems.insert(row);
    }
  }

  Color pickerColor = const Color(0xFFFF5252);
  Color currentColor = const Color(0xFFFF5252);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  createAlertSelectColor(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text(
        "Ok",
      ),
      onPressed: () {
        setState(() =>
            {currentColor = pickerColor, corAtual = pickerColor.toString()});
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Select Color : "),
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
    final Brightness _addNewItemTextBrightness = Theme.of(context).brightness;
    Color shoplistAccent = _addNewItemTextBrightness == Brightness.dark
        ? lightenColor(currentColor, 20)
        : darkenColor(currentColor, 20);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: IconButton(
                icon: const Icon(
                  Icons.save_outlined,
                ),
                onPressed: () async {
                  await _saveShopList();
                  await _saveItemsToShopList();
                  await widget.refreshShopLists();
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
          title: const Text('New Shoplist'),
        ),
        body: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 5, 5, 0),
              leading: const Icon(
                Icons.notes_outlined,
              ),
              title: TextField(
                autofocus: false,
                minLines: 1,
                maxLength: 30,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.sentences,
                controller: customControllerNome,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: "Shoplist name",
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
            Padding(
              padding : const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
              child: Card(
                elevation: 1,
                child: TextField(
                    minLines: 1,
                    maxLength: 200,
                    autofocus: false,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    textCapitalization: TextCapitalization.sentences,
                    controller: customControllerAddNewItem,
                    onSubmitted: (value) => {
                      if(customControllerAddNewItem.text.isNotEmpty){
                        _addItemToShopList(),
                        refreshList(),
                        customControllerAddNewItem.text = ""
                     }
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
                          Icons.add_outlined,
                          color: shoplistAccent.withOpacity(0.7),
                        ),
                        hintText: "New item",
                        hintStyle: TextStyle(
                          color: shoplistAccent.withOpacity(0.6).withOpacity(0.7),
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
                      itemCount: items.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return ItemNewShopList(
                          key: UniqueKey(),
                          item: Item(
                            id: items[index].id,
                            nome: items[index].nome,
                            estado: items[index].estado,
                            idShopList: items[index].idShopList,
                          ),
                          updateItem: updateItem,
                          deleteItem: _deleteItem,
                        );
                      }),
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
