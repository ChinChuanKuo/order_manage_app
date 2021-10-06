import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/category_models.dart';

class Suggest {
  Category category;
  DataJson date;
  DataJson time;

  Suggest({
    required this.category,
    required this.date,
    required this.time,
  });

  factory Suggest.fromJson(Map<String, dynamic> json) {
    return Suggest(
      category: Category.fromJson(json["category"]),
      date: DataJson.fromJson(json["date"]),
      time: DataJson.fromJson(json["time"]),
    );
  }
}
