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

class ShopDelete extends StatefulWidget {
  final Category category;
  final void Function(Category category)? onRemove;

  const ShopDelete({
    Key? key,
    required this.category,
    required this.onRemove,
  }) : super(key: key);

  @override
  _ShopDeleteState createState() => _ShopDeleteState();
}

class _ShopDeleteState extends State<ShopDelete> {
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
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

  Future<void> onPressedSure() async {
    final response = await http
        .post(Uri.http(APi.shop[12]["url"], APi.shop[12]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
      "requiredinfo": json
          .encode(RequireidJson.initialState(this.widget.category.requireid)),
    }, headers: {
      "Accept": "application/json"
    });
    final statusCode = response.statusCode == 200;
    if (statusCode) {
      controller.success();
      this.widget.onRemove!(this.widget.category);
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SheetTile(
          onCancel: onPressedCancel,
          title:
              '${AppLocalizations.of(context)!.deleteText} ${AppLocalizations.of(context)!.shopText}',
        ),
        SizedBox(height: screenSize.height * 0.01),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            title: Text(
              '${AppLocalizations.of(context)!.nameText}:${this.widget.category.shop.name}',
              style: Fontstyle.device(Colors.black ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            title: Text(
              '${AppLocalizations.of(context)!.phoneText}:${this.widget.category.shop.phone}',
              style: Fontstyle.device(Colors.black ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            title: Text(
              '${AppLocalizations.of(context)!.addressText}:${this.widget.category.shop.address}',
              style: Fontstyle.device(Colors.black ),
            ),
          ),
        ),
        Expanded(child: SizedBox.shrink()),
        RoundedButton(
          controller: controller,
          icon: Icons.delete_outline_outlined,
          text: AppLocalizations.of(context)!.deleteText,
          onPressed: onPressedSure,
        ),
      ],
    );
  }
}
