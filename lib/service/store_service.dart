import '../main.dart';
import '../redux/actions.dart';

abstract class StoreService {
  Future<void> loadShopLists() async {
    await store.dispatch(LoadShopListsAction());
  }
}
