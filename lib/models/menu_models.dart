import 'package:order_manage_app/json/json.dart';

class Menu {
  RequireidJson requireid;
  MenuJson menu;

  Menu({
    required this.requireid,
    required this.menu,
  });

  static Map<String, dynamic> initialState(Menu menu) => {
        "requireid": RequireidJson.initialState(menu.requireid),
        "menu": MenuJson.initialState(menu.menu),
      };

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      requireid: RequireidJson.fromJson(json["requireid"]),
      menu: MenuJson.fromJson(json["menu"]),
    );
  }
}
