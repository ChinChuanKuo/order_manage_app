import 'package:order_manage_app/json/json.dart';

class Category {
  RequireidJson requireid;
  ShopJson shop;

  Category({
    required this.requireid,
    required this.shop,
  });

  static Map<String, dynamic> initialState(Category category) => {
        "requireid": RequireidJson.initialState(category.requireid),
        "shop": ShopJson.initialState(category.shop),
      };

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      requireid: RequireidJson.fromJson(json["requireid"]),
      shop: ShopJson.fromJson(json["shop"]),
    );
  }
}
