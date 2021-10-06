import 'package:order_manage_app/json/json.dart';

class Office {
  DataJson item;
  ClientJson client;
  ActionJson action;

  Office({
    required this.item,
    required this.client,
    required this.action,
  });

  static Map<String, dynamic> initialState(Office client) => {
        "item": DataJson.initialState(client.item),
        "client": ClientJson.initialState(client.client),
      };

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      item: DataJson.fromJson(json["item"]),
      client: ClientJson.fromJson(json["client"]),
      action: ActionJson.fromJson(json["action"]),
    );
  }
}
