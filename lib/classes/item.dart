class Item{
   int id;
   String nome;
   int estado;  // 0 or 1
   int idShopList;

  Item({required this.id,required this.nome,required this.estado,required this.idShopList});

   factory Item.fromMap(Map<String, dynamic> map) {
     return Item(
       id: map['id'],
       nome: map['nome'],
       estado : map['estado'],
       idShopList: map['idShopList'],
     );
   }
}