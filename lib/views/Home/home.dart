import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_manage_app/apis/apis.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/source/source.dart';
import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/views/views.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserInfo? currentUser;
  Choose? choose;
  List<Shop>? shops;
  List<Statist>? statists;

  @override
  void initState() {
    currentUser = null;
    choose = null;
    shops = null;
    statists = null;
    initialState();
    // TODO: implement initState
    super.initState();
  }

  void initialState() {
    new Timer(new Duration(milliseconds: 500), fetchUserInfo);
    new Timer(new Duration(milliseconds: 1500), fetchChoose);
    new Timer(new Duration(milliseconds: 2500), fetchShops);
    new Timer(new Duration(milliseconds: 2500), fetchStatist);
  }

  UserInfo parseInfo(String responseBody) =>
      UserInfo.fromJson(json.decode(responseBody));

  Future fetchUserInfo() async {
    final response = await http.get(
        Uri.http(APi.user[0]["url"], APi.user[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => currentUser = parseInfo(response.body));
  }

  Choose parseChoose(String responseBody) =>
      Choose.fromJson(json.decode(responseBody));

  Future fetchChoose() async {
    final response = await http
        .post(Uri.http(APi.shop[0]["url"], APi.shop[0]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
    }, headers: {
      "Accept": "application/json"
    });
    if (response.statusCode == 200)
      setState(() => choose = parseChoose(response.body));
  }

  List<Shop> parseShops(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Shop>((data) => Shop.fromJson(data)).toList();
  }

  Future fetchShops() async {
    final response = await http
        .post(Uri.http(APi.shop[1]["url"], APi.shop[1]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
    }, headers: {
      "Accept": "application/json"
    });
    if (response.statusCode == 200)
      setState(() => shops = parseShops(response.body));
  }

  List<Statist> parseStatist(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Statist>((data) => Statist.fromJson(data)).toList();
  }

  Future fetchStatist() async {
    final response = await http.get(
        Uri.http(APi.shop[2]["url"], APi.shop[2]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => statists = parseStatist(response.body));
  }

  int findShopIndex(Category category) => shops!.indexWhere((element) =>
      element.category.requireid.orderid == category.requireid.orderid);

  void onRestoreShop(Category category, Menu menu) =>
      setState(() => shops![findShopIndex(category)].items.insert(0, menu));

  void onPressedMobileShop(Category category) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: MenuCreate(category: category, onRestore: onRestoreShop),
        ),
      );

  void onPressedDesktopShop(Category category) => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: MenuCreate(category: category, onRestore: onRestoreShop),
          ),
        ),
      );

  void onPressedMobileStop(Category category) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: ShopDelete(category: category, onRemove: onRemoveShop),
        ),
      );

  void onPressedDesktopStop(Category category) => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: ShopDelete(category: category, onRemove: onRemoveShop),
          ),
        ),
      );

  void onRemoveMenu(Category category, Menu menu) =>
      setState(() => shops![findShopIndex(category)].items.remove(menu));

  void onGestureMobileMenu(Category category, Menu menu) =>
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: MenuOption(
            category: category,
            menu: menu,
            onRemove: onRemoveMenu,
            onRestore: onRestoreShop,
          ),
        ),
      );

  void onGestureDesktopMenu(Category category, Menu menu) => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: MenuOption(
              category: category,
              menu: menu,
              onRemove: onRemoveMenu,
              onRestore: onRestoreShop,
            ),
          ),
        ),
      );

  void onCreateShop(Category category) => setState(() => shops!.insert(
      0, new Shop(category: category, items: <Menu>[], ordered: false)));

  void onTapMobilePlus() => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: ShopCreate(onCreate: onCreateShop),
        ),
      );

  void onTapDesktopPlus() => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: ShopCreate(onCreate: onCreateShop),
          ),
        ),
      );

  void onTapMobileSuggest() => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: SuggestOption(onCreate: onCreateShop),
        ),
      );

  void onTapDesktopSuggest() => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: SuggestOption(onCreate: onCreateShop),
          ),
        ),
      );

  DataJson parseData(String responseBody) =>
      DataJson.fromJson(json.decode(responseBody));

  void onTapClose() async {
    final response = await http
        .post(Uri.http(APi.shop[4]["url"], APi.shop[4]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
      "requiredinfo": json
          .encode(RequireidJson.initialState(choose!.shop.category.requireid)),
    }, headers: {
      "Accept": "application/json"
    });
    final statusCode = response.statusCode == 200;
    if (statusCode)
      setState(() {
        choose!.time = parseData(response.body);
        choose!.closed = true;
        choose!.opened = false;
      });
    CustomSnackBar.showWidget(
      context,
      new Duration(seconds: 5),
      Responsive.isMobile(context)
          ? SnackBarBehavior.fixed
          : SnackBarBehavior.floating,
      CustomSnackBar.snackColor(statusCode),
      Row(children: [
        Icon(Icons.check, color: Theme.of(context).primaryColor),
        SizedBox(width: 8.0),
        Text(CustomSnackBar.snackText(statusCode, context))
      ]),
    );
  }

  void onSetupChoose(Choose item) => setState(() => choose = item);

  void onRemoveShop(Category category) => setState(() {
        shops!.removeAt(findShopIndex(category));
        shops!.insert(
          0,
          new Shop(
            category: choose!.shop.category,
            items: choose!.shop.items,
            ordered: false,
          ),
        );
      });

  void onTapMobileOpen() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: 07, minute: 00));
    if (newTime != null)
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: BusinessOption(
            category: choose!.shop.category,
            time: newTime,
            onSetup: onSetupChoose,
            onRemove: onRemoveShop,
          ),
        ),
      );
  }

  void onTapDesktopOpen() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: 07, minute: 00));
    if (newTime != null)
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: BusinessOption(
              category: choose!.shop.category,
              time: newTime,
              onSetup: onSetupChoose,
              onRemove: onRemoveShop,
            ),
          ),
        ),
      );
  }

  void onTapWait() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: 07, minute: 00));
    if (newTime != null) {
      final response = await http
          .post(Uri.http(APi.shop[6]["url"], APi.shop[6]["route"]), body: {
        "clientinfo": json.encode(await ClientSource.initialState()),
        "deviceinfo": json.encode(await DeviceSource.initialState()),
        "requiredinfo": json.encode(
            RequireidJson.initialState(choose!.shop.category.requireid)),
        "timeinfo": json.encode(
            DataSource.initialState("${newTime.hour}:${newTime.minute}")),
      }, headers: {
        "Accept": "application/json"
      });
      final statusCode = response.statusCode == 200;
      if (statusCode) setState(() => choose!.time = parseData(response.body));
      CustomSnackBar.showWidget(
        context,
        new Duration(seconds: 5),
        Responsive.isMobile(context)
            ? SnackBarBehavior.fixed
            : SnackBarBehavior.floating,
        CustomSnackBar.snackColor(statusCode),
        Row(children: [
          Icon(Icons.check, color: Theme.of(context).primaryColor),
          SizedBox(width: 8.0),
          Text(CustomSnackBar.snackText(statusCode, context))
        ]),
      );
    }
  }

  void onTapRestart() async {
    final response = await http
        .post(Uri.http(APi.shop[7]["url"], APi.shop[7]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
      "requiredinfo": json
          .encode(RequireidJson.initialState(choose!.shop.category.requireid)),
    }, headers: {
      "Accept": "application/json"
    });
    final statusCode = response.statusCode == 200;
    if (statusCode)
      setState(() {
        choose!.closed = false;
        choose!.opened = true;
        choose!.time = parseData(response.body);
      });
    CustomSnackBar.showWidget(
      context,
      new Duration(seconds: 5),
      Responsive.isMobile(context)
          ? SnackBarBehavior.fixed
          : SnackBarBehavior.floating,
      CustomSnackBar.snackColor(statusCode),
      Row(children: [
        Icon(Icons.check, color: Theme.of(context).primaryColor),
        SizedBox(width: 8.0),
        Text(CustomSnackBar.snackText(statusCode, context))
      ]),
    );
  }

  void onTapPreview() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewView(
            category: choose!.shop.category,
          ),
        ),
      );

  void onPressedDesktopMore(Menu menu) => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: MoreOption(
                menu: menu,
                onIncrease: onTapDesktopIncrease,
                onSoldout: onTapDesktopSoldout),
          ),
        ),
      );

  void onPressedMobileMore(Menu menu) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: MoreOption(
              menu: menu,
              onIncrease: onTapMobileIncrease,
              onSoldout: onTapMobileSoldout),
        ),
      );

  void onTapDesktopIncrease(Menu menu) => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: IncreaseCreate(menu: menu),
          ),
        ),
      );

  void onTapMobileIncrease(Menu menu) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: IncreaseCreate(menu: menu),
        ),
      );

  void onTapDesktopSoldout(Menu menu) => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: null,
          ),
        ),
      );

  void onTapMobileSoldout(Menu menu) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: null,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Module(
      selectedIndex: 0,
      title: AppLocalizations.of(context)!.manageTile,
      body: shops == null
          ? Responsive(
              mobile: MobileHomeShimmer(),
              desktop: DesktopHomeShimmer(),
            )
          : Responsive(
              mobile: MobileHomeView(
                choose: choose,
                shops: shops,
                statists: statists,
                onPressedShop: onPressedMobileShop,
                onPressedStop: onPressedMobileStop,
                onGestureMenu: onGestureMobileMenu,
                onPressedMore: onPressedMobileMore,
              ),
              desktop: DesktopHomeView(
                choose: choose,
                shops: shops,
                statists: statists,
                onPressedShop:
                    isDesktop ? onPressedDesktopShop : onPressedMobileShop,
                onPressedStop:
                    isDesktop ? onPressedDesktopStop : onPressedMobileStop,
                onGestureMenu:
                    isDesktop ? onGestureDesktopMenu : onGestureMobileMenu,
                onPressedMore:
                    isDesktop ? onPressedDesktopMore : onPressedMobileMore,
              ),
            ),
      floatingActionButton: SpeedDial(
        icon: Icons.keyboard_arrow_up_outlined,
        activeIcon: Icons.clear_outlined,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Palette.disabledColor,
        activeForegroundColor: Theme.of(context).primaryColor,
        activeBackgroundColor: Palette.orderColor,
        label: Text(AppLocalizations.of(context)!.moreText),
        spaceBetweenChildren: 8.0,
        children: choose == null || choose!.shop.items.length == 0
            ? [
                SpeedDialChild(
                  child: Icon(Icons.add_business_outlined),
                  backgroundColor: Palette.orderColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  label: AppLocalizations.of(context)!.createText,
                  labelStyle: Fontstyle.subtitle(Colors.black87),
                  onTap: isDesktop ? onTapDesktopPlus : onTapMobilePlus,
                ),
                SpeedDialChild(
                  child: Icon(Icons.settings_suggest_outlined),
                  backgroundColor: Palette.orderColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  label: AppLocalizations.of(context)!.suggestTile,
                  labelStyle: Fontstyle.subtitle(Colors.black87),
                  onTap: isDesktop ? onTapDesktopSuggest : onTapMobileSuggest,
                ),
                SpeedDialChild(
                  child: Icon(Icons.business_outlined),
                  backgroundColor: Palette.orderColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  label: AppLocalizations.of(context)!.businessText,
                  labelStyle: Fontstyle.subtitle(Colors.black87),
                  onTap: isDesktop ? onTapDesktopOpen : onTapMobileOpen,
                ),
              ]
            : choose!.opened
                ? [
                    SpeedDialChild(
                      child: Icon(Icons.add_business_outlined),
                      backgroundColor: Palette.orderColor,
                      foregroundColor: Theme.of(context).primaryColor,
                      label: AppLocalizations.of(context)!.createText,
                      labelStyle: Fontstyle.subtitle(Colors.black87),
                      onTap: isDesktop ? onTapDesktopPlus : onTapMobilePlus,
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.settings_suggest_outlined),
                      backgroundColor: Palette.orderColor,
                      foregroundColor: Theme.of(context).primaryColor,
                      label: AppLocalizations.of(context)!.suggestTile,
                      labelStyle: Fontstyle.subtitle(Colors.black87),
                      onTap:
                          isDesktop ? onTapDesktopSuggest : onTapMobileSuggest,
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.remove_outlined),
                      backgroundColor: Palette.orderColor,
                      foregroundColor: Theme.of(context).primaryColor,
                      label: AppLocalizations.of(context)!.closedText,
                      labelStyle: Fontstyle.subtitle(Colors.black87),
                      onTap: onTapClose,
                    ),
                  ]
                : choose!.closed
                    ? [
                        SpeedDialChild(
                          child: Icon(Icons.add_business_outlined),
                          backgroundColor: Palette.orderColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          label: AppLocalizations.of(context)!.createText,
                          labelStyle: Fontstyle.subtitle(Colors.black87),
                          onTap: isDesktop ? onTapDesktopPlus : onTapMobilePlus,
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.settings_suggest_outlined),
                          backgroundColor: Palette.orderColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          labelStyle: Fontstyle.subtitle(Colors.black87),
                          label: AppLocalizations.of(context)!.suggestTile,
                          onTap: isDesktop
                              ? onTapDesktopSuggest
                              : onTapMobileSuggest,
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.business_outlined),
                          backgroundColor: Palette.orderColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          label: AppLocalizations.of(context)!.businessText,
                          labelStyle: Fontstyle.subtitle(Colors.black87),
                          onTap: isDesktop ? onTapDesktopOpen : onTapMobileOpen,
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.restart_alt_outlined),
                          backgroundColor: Palette.orderColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          label: AppLocalizations.of(context)!.restartText,
                          labelStyle: Fontstyle.subtitle(Colors.black87),
                          onTap: onTapRestart,
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.preview_outlined),
                          backgroundColor: Palette.orderColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          label: AppLocalizations.of(context)!.previewTile,
                          labelStyle: Fontstyle.subtitle(Colors.black87),
                          onTap: onTapPreview,
                        ),
                      ]
                    : [
                        SpeedDialChild(
                          child: Icon(Icons.add_business_outlined),
                          backgroundColor: Palette.orderColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          label: AppLocalizations.of(context)!.createText,
                          labelStyle: Fontstyle.subtitle(Colors.black87),
                          onTap: isDesktop ? onTapDesktopPlus : onTapMobilePlus,
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.settings_suggest_outlined),
                          backgroundColor: Palette.orderColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          labelStyle: Fontstyle.subtitle(Colors.black87),
                          label: AppLocalizations.of(context)!.suggestTile,
                          onTap: isDesktop
                              ? onTapDesktopSuggest
                              : onTapMobileSuggest,
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.timer_outlined),
                          backgroundColor: Palette.orderColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          label: AppLocalizations.of(context)!.chooseText,
                          labelStyle: Fontstyle.subtitle(Colors.black87),
                          onTap: onTapWait,
                        ),
                      ],
      ),
    );
  }
}

class MobileHomeView extends StatelessWidget {
  final Choose? choose;
  final List<Shop>? shops;
  final List<Statist>? statists;
  final void Function(Category category)? onPressedShop;
  final void Function(Category category)? onPressedStop;
  final void Function(Category category, Menu menu)? onGestureMenu;
  final void Function(Menu menu) onPressedMore;

  const MobileHomeView({
    Key? key,
    required this.choose,
    required this.shops,
    required this.statists,
    required this.onPressedShop,
    required this.onPressedStop,
    required this.onGestureMenu,
    required this.onPressedMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 200.0),
            child: RectangleCard(
              child: statists == null
                  ? WidgetLoading().centerCircular
                  : StatistBarChart(statists: statists!),
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: shops!.length,
              itemBuilder: (BuildContext context, int index) {
                final Shop shop = shops![index];
                return ShopList(
                  shop: shop,
                  onPressedShop: onPressedShop,
                  onPressedStop: onPressedStop,
                  onGesture: onGestureMenu,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MobileHomeShimmer extends StatelessWidget {
  const MobileHomeShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: Column(
        children: [
          Container(
              constraints: BoxConstraints(maxHeight: 200.0),
              child: WidgetLoading().centerCircular),
          SizedBox(height: screenSize.height * 0.01),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 1,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemBuilder: (BuildContext context, int index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: WidgetShimmer.rectangular(width: 50.0),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) =>
                        shimmerMenu(screenSize),
                  ),
                  SizedBox(height: screenSize.height * 0.0025),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DesktopHomeView extends StatelessWidget {
  final Choose? choose;
  final List<Shop>? shops;
  final List<Statist>? statists;
  final void Function(Category category)? onPressedShop;
  final void Function(Category category)? onPressedStop;
  final void Function(Category category, Menu menu)? onGestureMenu;
  final void Function(Menu menu) onPressedMore;

  const DesktopHomeView({
    Key? key,
    required this.choose,
    required this.shops,
    required this.statists,
    required this.onPressedShop,
    required this.onPressedStop,
    required this.onGestureMenu,
    required this.onPressedMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth =
        isDesktop ? screenSize.width - 480.0 : screenSize.width - 380.0;
    return Row(
      children: [
        if (isDesktop)
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0),
                child: null,
              ),
            ),
          ),
        Container(
          margin: isDesktop
              ? EdgeInsets.only(top: 12.0)
              : EdgeInsets.only(top: 12.0, left: 48.0),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 200.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: RectangleCard(
                          child: statists == null
                              ? WidgetLoading().centerCircular
                              : StatistBarChart(statists: statists),
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Expanded(
                        child: RectangleCard(
                          child: statists == null
                              ? WidgetLoading().centerCircular
                              : StatistEsianChart(statists: statists),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: shops!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Shop shop = shops![index];
                      return ShopList(
                        shop: shop,
                        onPressedShop: onPressedShop,
                        onPressedStop: onPressedStop,
                        onGesture: onGestureMenu,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
              child: ChooseList(
                choose: choose!,
                onPressed: onPressedMore,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DesktopHomeShimmer extends StatelessWidget {
  const DesktopHomeShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth =
        isDesktop ? screenSize.width - 480.0 : screenSize.width - 380.0;
    return Row(
      children: [
        if (isDesktop)
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0),
                child: null,
              ),
            ),
          ),
        Container(
          margin: isDesktop
              ? EdgeInsets.only(top: 12.0)
              : EdgeInsets.only(top: 12.0, left: 48.0),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: 200.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: WidgetLoading().centerCircular),
                    Expanded(child: WidgetLoading().centerCircular),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: WidgetShimmer.rectangular(width: 50.0),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) =>
                            shimmerMenu(screenSize),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
              child: OrderLoading(),
            ),
          ),
        ),
      ],
    );
  }
}

Widget shimmerMenu(Size screenSize) => ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
      title: WidgetShimmer.rectangular(),
      trailing: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(width: screenSize.width * 0.025),
          WidgetShimmer.rectangular(width: 50.0),
          SizedBox(width: screenSize.width * 0.025),
          WidgetShimmer.rectangular(width: 50.0),
        ],
      ),
    );
