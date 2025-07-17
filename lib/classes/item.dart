class Item {
  int id;
  String name;
  int idShopList;

  Item({required this.id, required this.name, required this.idShopList});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      idShopList: map['idShopList'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'idShopList': idShopList,
    };
  }
}
