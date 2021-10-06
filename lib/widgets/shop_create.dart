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

class ShopCreate extends StatefulWidget {
  final void Function(Category category)? onCreate;

  const ShopCreate({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  _ShopCreateState createState() => _ShopCreateState();
}

class _ShopCreateState extends State<ShopCreate> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    nameController = new TextEditingController();
    phoneController = new TextEditingController();
    addressController = new TextEditingController();
    controller = new RoundedLoadingButtonController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void onPressedCancel() => Navigator.pop(context);

  Category parseCategory(String responseBody) =>
      Category.fromJson(json.decode(responseBody));

  Future<void> onPressedSure() async {
    final String name = nameController.text,
        phone = phoneController.text,
        address = addressController.text;
    if (name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty) {
      final response = await http
          .post(Uri.http(APi.shop[11]["url"], APi.shop[11]["route"]), body: {
        "clientinfo": json.encode(await ClientSource.initialState()),
        "deviceinfo": json.encode(await DeviceSource.initialState()),
        "shopinfo": json.encode(ShopJson.initialState(
            ShopJson(name: name, phone: phone, address: address))),
      }, headers: {
        "Accept": "application/json"
      });
      final statusCode = response.statusCode == 200;
      if (statusCode) {
        controller.success();
        this.widget.onCreate!(parseCategory(response.body));
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
          title:
              '${AppLocalizations.of(context)!.createText} ${AppLocalizations.of(context)!.shopText}',
          showed: !isDesktop,
          text: AppLocalizations.of(context)!.createText,
          controller: controller,
          onPressed: onPressedSure,
        ),
        SizedBox(height: screenSize.height * 0.025),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                title: CustomInputBar(
                  hintText: AppLocalizations.of(context)!.nameText,
                  icon: Icons.restaurant_outlined,
                  controller: nameController,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              ListTile(
                title: CustomInputBar(
                  hintText: AppLocalizations.of(context)!.phoneText,
                  icon: Icons.phone_outlined,
                  controller: phoneController,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              ListTile(
                title: CustomInputBar(
                  hintText: AppLocalizations.of(context)!.addressText,
                  icon: Icons.location_city_outlined,
                  controller: addressController,
                ),
              ),
            ],
          ),
        ),
        if (isDesktop)
          RoundedButton(
            controller: controller,
            icon: Icons.add_outlined,
            text: AppLocalizations.of(context)!.createText,
            onPressed: onPressedSure,
          ),
      ],
    );
  }
}
