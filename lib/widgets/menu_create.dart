import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_manage_app/apis/apis.dart';
import 'package:order_manage_app/source/source.dart';
import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MenuCreate extends StatefulWidget {
  final Category category;
  final void Function(Category category, Menu menu)? onRestore;

  const MenuCreate({
    Key? key,
    required this.category,
    required this.onRestore,
  }) : super(key: key);

  @override
  _MenuCreateState createState() => _MenuCreateState();
}

class _MenuCreateState extends State<MenuCreate> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    nameController = new TextEditingController();
    priceController = new TextEditingController();
    controller = new RoundedLoadingButtonController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void onPressedCancel() => Navigator.pop(context);

  Menu parseMenu(String responseBody) =>
      Menu.fromJson(json.decode(responseBody));

  Future<void> onPressedSure() async {
    final String name = nameController.text, price = priceController.text;
    if (name.isNotEmpty && price.isNotEmpty) {
      final response = await http
          .post(Uri.http(APi.shop[10]["url"], APi.shop[10]["route"]), body: {
        "clientinfo": json.encode(await ClientSource.initialState()),
        "deviceinfo": json.encode(await DeviceSource.initialState()),
        "requiredinfo": json
            .encode(RequireidJson.initialState(this.widget.category.requireid)),
        "iteminfo": json.encode(ItemSource.initialState(name, price)),
      }, headers: {
        "Accept": "application/json"
      });
      final statusCode = response.statusCode == 200;
      if (statusCode) {
        controller.success();
        this.widget.onRestore!(this.widget.category, parseMenu(response.body));
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
    } else
      controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SheetTile(
          onCancel: onPressedCancel,
          title: this.widget.category.shop.name,
          showed: !isDesktop,
          text: AppLocalizations.of(context)!.addText,
          controller: controller,
          onPressed: onPressedSure,
        ),
        Expanded(
          child: ListView(
            children: [
              SizedBox(height: screenSize.height * 0.025),
              ListTile(
                title: CustomInputBar(
                  hintText: AppLocalizations.of(context)!.nameText,
                  icon: Icons.restaurant_menu_outlined,
                  controller: nameController,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              ListTile(
                title: CustomInputBar(
                  hintText: AppLocalizations.of(context)!.priceText,
                  icon: Icons.money_outlined,
                  controller: priceController,
                ),
              ),
            ],
          ),
        ),
        if (isDesktop)
          RoundedButton(
            controller: controller,
            icon: Icons.add_outlined,
            text: AppLocalizations.of(context)!.addText,
            onPressed: onPressedSure,
          ),
      ],
    );
  }
}
