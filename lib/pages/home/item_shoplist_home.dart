import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';
import 'package:flutter_animator/flutter_animator.dart';

import '../../util/utils_functions.dart';

class ItemShopListHome extends StatefulWidget {
  @override
  _ItemShopListHomeState createState() => _ItemShopListHomeState();

  Item item;
  Function(int) getItemsRefreshShopList;
  Color shopListColor;

  ItemShopListHome(
      {Key key, this.item, this.getItemsRefreshShopList, this.shopListColor})
      : super(key: key);
}

class _ItemShopListHomeState extends State<ItemShopListHome> {

  final GlobalKey<InOutAnimationState> inOutAnimation =
      GlobalKey<InOutAnimationState>();

  bool value = false;

  void _updateEstadoItem(bool state) async {
    final dbShopList = ItemDao.instance;
    Map<String, dynamic> row = {
      ItemDao.columnId: widget.item.id,
      ItemDao.columnEstado: state ? 1 : 0,
    };
    final update = await dbShopList.update(row);
  }

  @override
  Widget build(BuildContext context) {

    final Brightness _dotIconBrightness = Theme.of(context).brightness;

    return InOutAnimation(
      autoPlay: InOutAnimationStatus.None,
      key: inOutAnimation,
      inDefinition: FadeInAnimation(),
      outDefinition: FadeOutAnimation(
          preferences: const AnimationPreferences(duration: Duration(milliseconds: 450))
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(7, 7, 0, 0),
          child: Icon(
            Icons.circle,
            color: _dotIconBrightness == Brightness.dark
                ? lightenColor(widget.shopListColor, 20)
                : darkenColor(widget.shopListColor, 20),
           // color: widget.shopListColor,
            size: 10,
          ),
        ),
        title: Text(
          widget.item.nome,
        ),
        trailing: Checkbox(
          splashRadius: 30,
          value: widget.item.estado == 1 ? true : false,
          onChanged: (bool v) {
            inOutAnimation.currentState.animateOut();
            Future.delayed(const Duration(milliseconds: 250), () {
              _updateEstadoItem(v);
              widget.getItemsRefreshShopList(widget.item.idShopList);
            });
          },
        ),
      ),
    );
  }
}
