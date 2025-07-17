import 'item.dart';

class ShopList {
  final int id;
  final String name;
  final String color;
  List<Item>? items;

  ShopList({required this.id, required this.name, required this.color});

  factory ShopList.fromMap(Map<String, dynamic> map) {
    return ShopList(
      id: map['id'],
      name: map['name'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'color': color};
  }
}
