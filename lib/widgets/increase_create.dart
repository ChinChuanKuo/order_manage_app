import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_manage_app/apis/apis.dart';
import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/source/source.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class IncreaseCreate extends StatefulWidget {
  final Menu? menu;

  const IncreaseCreate({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  _IncreaseCreateState createState() => _IncreaseCreateState();
}

class _IncreaseCreateState extends State<IncreaseCreate> {
  Menu? menu;
  late TextEditingController priceController;
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    menu = this.widget.menu;
    priceController = new TextEditingController();
    controller = new RoundedLoadingButtonController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void onPressedCancel() => Navigator.pop(context);

  void onPressedSure() async {
    final String price = priceController.text;
    if (price.isNotEmpty) {
      final response = await http
          .post(Uri.http(APi.shop[13]["url"], APi.shop[13]["route"]), body: {
        "clientinfo": json.encode(await ClientSource.initialState()),
        "deviceinfo": json.encode(await DeviceSource.initialState()),
        "requiredinfo": json
            .encode(RequireidJson.initialState(this.widget.menu!.requireid)),
        "iteminfo":
            json.encode(ItemSource.initialState(menu!.menu.name, price)),
      }, headers: {
        "Accept": "application/json"
      });
      final statusCode = response.statusCode == 200;
      if (statusCode) {
        final String status = json.decode(response.body)["status"];
        if (status == "istrue") {
          controller.success();
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
            CustomSnackBar.snackColor(status),
            Row(children: [
              Icon(Icons.check, color: Theme.of(context).primaryColor),
              SizedBox(width: 8.0),
              Text(CustomSnackBar.snackText(status, context))
            ]),
          );
        }
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
          title: menu!.menu.name,
          showed: !isDesktop,
          text: AppLocalizations.of(context)!.sureText,
          controller: controller,
          onPressed: onPressedSure,
        ),
        SizedBox(height: screenSize.height * 0.025),
        Expanded(
          child: ListView(
            children: [
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
            icon: Icons.edit_outlined,
            text: AppLocalizations.of(context)!.sureText,
            onPressed: onPressedSure,
          ),
      ],
    );
  }
}
