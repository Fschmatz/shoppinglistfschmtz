import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';

class ContainerItemEditShopList extends StatefulWidget {
  @override
  _ContainerItemEditShopListState createState() => _ContainerItemEditShopListState();

  Item item;

  ContainerItemEditShopList({Key key, this.item})
      : super(key: key);
}

class _ContainerItemEditShopListState extends State<ContainerItemEditShopList> {
  bool value = false;

  TextEditingController customControllerNome = TextEditingController();
  TextEditingController customControllerQuant = TextEditingController();

  @override
  void initState() {
    super.initState();
    customControllerNome.text = widget.item.nome;
    customControllerQuant.text = widget.item.quantity.toString();
  }

  //padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 8, 10),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'^(\d+)?\d{0,2}'))
              ],
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              controller: customControllerQuant,
              textAlign: TextAlign.center,
              maxLength: 3,
              decoration: InputDecoration(
                  counterStyle: TextStyle(height: double.minPositive,),
                  counterText: "" // hide maxlength counter
              ),
              style: TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          const SizedBox(width: 20,),
          Flexible(
            flex: 6,
            child: TextField(
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: customControllerNome,
              style: TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          const SizedBox(width: 5,),
          Checkbox(
            activeColor: Theme.of(context).accentColor,
            value: value, //widget.item.estado == 0 ? false : true,
            onChanged: (bool v) {
              setState(() {
                value = v;
              });
            },
          ),
        ],
      ),
    );
  }
}
