import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';

class Total {
  List<DataJson> item;
  List<Menu> items;

  Total({
    required this.item,
    required this.items,
  });

  factory Total.fromJson(Map<String, dynamic> json) {
    return Total(
      item: json["item"]
          .map<DataJson>((data) => DataJson.fromJson(data))
          .toList(),
      items: json["items"].map<Menu>((data) => Menu.fromJson(data)).toList(),
    );
  }
}
