import 'package:order_manage_app/json/json.dart';

class Client {
  DataJson item;
  ClientJson client;

  Client({
    required this.item,
    required this.client,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      item: DataJson.fromJson(json["item"]),
      client: ClientJson.fromJson(json["client"]),
    );
  }
}
