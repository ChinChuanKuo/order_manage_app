import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_manage_app/apis/apis.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/source/source.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BusinessOption extends StatefulWidget {
  final Category? category;
  final TimeOfDay time;
  final void Function(Category category)? onRemove;
  final void Function(Choose choose)? onSetup;

  const BusinessOption({
    Key? key,
    required this.category,
    required this.time,
    required this.onRemove,
    required this.onSetup,
  }) : super(key: key);

  @override
  _BusinessOptionState createState() => _BusinessOptionState();
}

class _BusinessOptionState extends State<BusinessOption> {
  Category? item;
  List<Category>? categories;
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    item = this.widget.category;
    categories = null;
    controller = new RoundedLoadingButtonController();
    initialState();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void initialState() =>
      new Timer(new Duration(milliseconds: 1500), fetchCategories);

  List<Category> parseCategories(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Category>((data) => Category.fromJson(data)).toList();
  }

  Future fetchCategories() async {
    final response = await http.get(
        Uri.http(APi.shop[3]["url"], APi.shop[3]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => categories = parseCategories(response.body));
  }

  void onPressedCancel() => Navigator.pop(context);

  Choose parseChoose(String responseBody) =>
      Choose.fromJson(json.decode(responseBody));

  Future<void> onPressedSure() async {
    final response = await http
        .post(Uri.http(APi.shop[5]["url"], APi.shop[5]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
      "requiredinfo": json.encode(RequireidJson.initialState(item!.requireid)),
      "timeinfo": json.encode(DataSource.initialState(
          "${this.widget.time.hour}:${this.widget.time.minute}")),
    }, headers: {
      "Accept": "application/json"
    });
    final statusCode = response.statusCode == 200;
    if (statusCode) {
      controller.success();
      final Choose choose = parseChoose(response.body);
      this.widget.onRemove!(choose.shop.category);
      this.widget.onSetup!(choose);
      new Timer(new Duration(seconds: 5), () => Navigator.pop(context));
    } else {
      controller.error();
      new Timer(new Duration(seconds: 5), () => controller.reset());
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

  void onTapChecked(Category category) => setState(() => item = category);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SheetTile(
          onCancel: onPressedCancel,
          title:
              '${AppLocalizations.of(context)!.chooseText} ${AppLocalizations.of(context)!.shopText}',
          showed: !isDesktop,
          text: AppLocalizations.of(context)!.sureText,
          controller: controller,
          onPressed: onPressedSure,
        ),
        SizedBox(height: screenSize.height * 0.01),
        Expanded(
          child: categories == null
              ? WidgetLoading().centerCircular
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: categories!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Category category = categories![index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      leading: Icon(
                        item!.requireid.orderid == category.requireid.orderid
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank,
                        size: Parameter.iconSize,
                      ),
                      title: Text(
                        category.shop.name,
                        style: Fontstyle.device(Colors.black),
                      ),
                      onTap: () => onTapChecked(category),
                    );
                  },
                ),
        ),
        if (isDesktop)
          RoundedButton(
            controller: controller,
            icon: Icons.check_outlined,
            text: AppLocalizations.of(context)!.sureText,
            onPressed: onPressedSure,
          ),
      ],
    );
  }
}
