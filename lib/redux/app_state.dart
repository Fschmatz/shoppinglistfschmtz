import '../classes/item.dart';
import '../classes/shop_list.dart';

class AppState {
  List<ShopList> shopLists = [];

  AppState({required this.shopLists});

  static AppState initialState() => AppState(
        shopLists: [],
      );

  AppState copyWith({
    List<ShopList>? shopLists,
    ShopList? selectedShopList,
    Item? selectedItem,
  }) {
    return AppState(
      shopLists: shopLists ?? this.shopLists,
    );
  }
}
