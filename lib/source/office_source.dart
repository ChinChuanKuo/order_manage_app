import 'package:order_manage_app/models/models.dart';

class OfficeSource {
  static List<Map<String, dynamic>> initialState(Iterable<Office> clients) {
    List<Map<String, dynamic>> items = [];
    for (var client in clients) items.add(Office.initialState(client));
    return items;
  }
}
