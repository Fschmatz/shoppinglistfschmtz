import 'package:flutter/material.dart';
import 'package:shoppinglistfschmtz/classes/item.dart';
import 'package:shoppinglistfschmtz/db/item_dao.dart';
import 'package:flutter_animator/flutter_animator.dart';

class ItemShopListHome extends StatefulWidget {
  @override
  _ItemShopListHomeState createState() => _ItemShopListHomeState();

  Item item;
  Function(int) getItemsRefreshShopList;
  Color tileColor;

  RoundedRectangleBorder cardBorderRadius;

  ItemShopListHome({Key? key, required this.item, required this.getItemsRefreshShopList, required this.tileColor, required this.cardBorderRadius}) : super(key: key);
}

class _ItemShopListHomeState extends State<ItemShopListHome> {
  final GlobalKey<InOutAnimationState> inOutAnimation = GlobalKey<InOutAnimationState>();

  bool value = false;

  void _updateEstadoItem(bool state) async {
    final dbShopList = ItemDao.instance;
    Map<String, dynamic> row = {
      ItemDao.columnId: widget.item.id,
      ItemDao.columnEstado: state ? 1 : 0,
    };

    await dbShopList.update(row);
  }

  @override
  Widget build(BuildContext context) {

    return InOutAnimation(
      autoPlay: InOutAnimationStatus.None,
      key: inOutAnimation,
      inDefinition: FadeInAnimation(),
      outDefinition: SlideOutRightAnimation(preferences: const AnimationPreferences(duration: Duration(milliseconds: 700))),
      child: ListTile(
        tileColor: widget.tileColor,
        shape: widget.cardBorderRadius,
        contentPadding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
        leading: Checkbox(
          value: widget.item.estado == 1 ? true : false,
          onChanged: (bool? v) {
            inOutAnimation.currentState?.animateOut();
            Future.delayed(const Duration(milliseconds: 300), () {
              _updateEstadoItem(v!);
              widget.getItemsRefreshShopList(widget.item.idShopList);
            });
          },
        ),
        title: Text(
          widget.item.nome,
        ),
      ),
    );
  }
}
