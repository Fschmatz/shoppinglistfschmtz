import 'item.dart';

class ShopList{
  final int id;
  final String nome;
  final String cor;
  List<Item>? items;

  ShopList({required this.id,required this.nome,required this.cor});


  factory ShopList.fromMap(Map<String, dynamic> map) {
    return ShopList(
      id: map['id'],
      nome: map['nome'],
      cor : map['cor'],
    );
  }
}