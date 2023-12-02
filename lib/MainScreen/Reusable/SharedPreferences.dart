import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String cartKey = 'cart';

  static Future<List<String>> getCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(cartKey) ?? [];
  }

  static Future<void> saveCartItems(List<String> cartItems) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(cartKey, cartItems);
  }
}
