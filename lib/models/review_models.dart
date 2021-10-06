import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';

class Preview {
  List<DataJson> item;
  List<Order> items;

  Preview({
    required this.item,
    required this.items,
  });

  factory Preview.fromJson(Map<String, dynamic> json) {
    return Preview(
      item: json["item"]
          .map<DataJson>((data) => DataJson.fromJson(data))
          .toList(),
      items: json["items"].map<Order>((data) => Order.fromJson(data)).toList(),
    );
  }
}
