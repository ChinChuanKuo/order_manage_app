import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';

class Calendar {
  Category category;
  DataJson stdate;
  DataJson endate;
  bool success;
  bool failed;

  Calendar({
    required this.category,
    required this.stdate,
    required this.endate,
    required this.success,
    required this.failed,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      category: Category.fromJson(json["category"]),
      stdate: DataJson.fromJson(json["stdate"]),
      endate: DataJson.fromJson(json["endate"]),
      success: json["success"] == true,
      failed: json["failed"] == true,
    );
  }
}
