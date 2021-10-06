import 'package:order_manage_app/json/json.dart';

class Store {
  RequireidJson requireid;
  StoreJson store;
  DataJson stdate;
  DataJson endate;
  bool success;
  bool failed;

  Store({
    required this.requireid,
    required this.store,
    required this.stdate,
    required this.endate,
    required this.success,
    required this.failed,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      requireid: RequireidJson.fromJson(json["requireid"]),
      store: StoreJson.fromJson(json["store"]),
      stdate: DataJson.fromJson(json["stdate"]),
      endate: DataJson.fromJson(json["endate"]),
      success: json["success"] == true,
      failed: json["failed"] == true,
    );
  }
}
