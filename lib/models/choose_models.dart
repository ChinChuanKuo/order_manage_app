import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';

class Choose {
  Shop shop;
  DataJson time;
  bool opened;
  bool closed;

  Choose({
    required this.shop,
    required this.time,
    required this.opened,
    required this.closed,
  });

  factory Choose.fromJson(Map<String, dynamic> json) {
    return Choose(
      shop: Shop.fromJson(json["shop"]),
      time: DataJson.fromJson(json["time"]),
      opened: json["opened"] == true,
      closed: json["closed"] == true,
    );
  }
}
