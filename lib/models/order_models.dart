import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';

class Order {
  Menu menu;
  ClientJson client;

  Order({
    required this.menu,
    required this.client,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      menu: Menu.fromJson(json["menu"]),
      client: ClientJson.fromJson(json["client"]),
    );
  }
}
