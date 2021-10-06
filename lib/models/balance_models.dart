import 'package:order_manage_app/json/json.dart';

class Balance {
  RequireidJson requireid;
  StoreJson store;
  DataJson time;
  ClientJson client;

  Balance({
    required this.requireid,
    required this.store,
    required this.time,
    required this.client,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      requireid: RequireidJson.fromJson(json["requireid"]),
      store: StoreJson.fromJson(json["store"]),
      time: DataJson.fromJson(json["time"]),
      client: ClientJson.fromJson(json["client"]),
    );
  }
}
