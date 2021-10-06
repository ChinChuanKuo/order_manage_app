import 'package:order_manage_app/models/models.dart';

class Shop {
  Category category;
  bool ordered;
  List<Menu> items;

  Shop({
    required this.category,
    required this.ordered,
    required this.items,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      category: Category.fromJson(json["category"]),
      ordered: json["ordered"] == true,
      items: json["items"].map<Menu>((data) => Menu.fromJson(data)).toList(),
    );
  }
}
