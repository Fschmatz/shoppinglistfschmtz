import 'package:shoppinglistfschmtz/service/shop_list_service.dart';
import '../classes/shop_list.dart';
import 'app_action.dart';
import 'app_state.dart';

class LoadShopListsAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    List<ShopList> shopLists = await ShopListService().queryAllWithItems();

    return state.copyWith(shopLists: shopLists);
  }
}

class SaveShopListAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    List<ShopList> shopLists = await ShopListService().queryAllWithItems();

    return state.copyWith(shopLists: shopLists);
  }
}
