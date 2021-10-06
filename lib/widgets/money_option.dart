import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_manage_app/apis/apis.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/source/source.dart';
import 'package:order_manage_app/json/json.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MoneyOption extends StatefulWidget {
  final String title;
  final String authority;
  final String unencodedPath;
  final void Function()? onStartup;

  const MoneyOption({
    Key? key,
    required this.title,
    required this.authority,
    required this.unencodedPath,
    required this.onStartup,
  }) : super(key: key);

  @override
  _MoneyOptionState createState() => _MoneyOptionState();
}

class _MoneyOptionState extends State<MoneyOption> {
  Client? client;
  late TextEditingController emailController;
  late TextEditingController storeControlller;
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    client = null;
    emailController = new TextEditingController();
    storeControlller = new TextEditingController();
    controller = new RoundedLoadingButtonController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    storeControlller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void onPressedCancel() => Navigator.pop(context);

  Client parseClient(String responseBody) =>
      Client.fromJson(json.decode(responseBody));

  void onSubmitted(String value) async {
    if (value.isNotEmpty) {
      final response = await http.post(
          Uri.http(
            APi.bank[5]["url"],
            APi.bank[5]["route"],
          ),
          body: {
            "clientinfo": json.encode(await ClientSource.initialState()),
            "deviceinfo": json.encode(await DeviceSource.initialState()),
            "infotext": value,
          },
          headers: {
            "Accept": "application/json"
          });
      if (response.statusCode == 200)
        setState(() => client = parseClient(response.body));
    }
  }

  Store parseStore(String responseBody) =>
      Store.fromJson(json.decode(responseBody));

  void onPressedSure() async {
    final String email = emailController.text, store = storeControlller.text;
    if (email.isNotEmpty && store.isNotEmpty && client != null) {
      final response = await http.post(
          Uri.http(this.widget.authority, this.widget.unencodedPath),
          body: {
            "clientinfo": json.encode(await ClientSource.initialState()),
            "deviceinfo": json.encode(await DeviceSource.initialState()),
            "notherinfo": json.encode(ClientJson.initialState(client!.client)),
            "storetext": store,
          },
          headers: {
            "Accept": "application/json"
          });
      final statusCode = response.statusCode == 200;
      if (statusCode) {
        controller.success();
        this.widget.onStartup!();
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
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SheetTile(onCancel: onPressedCancel, title: this.widget.title),
        Expanded(
          child: ListView(
            children: [
              client == null
                  ? SizedBox(height: screenSize.height * 0.02)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              title: Text(
                                '${AppLocalizations.of(context)!.nameText}：${client!.client.email}',
                                style: Fontstyle.info(Colors.black54),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              title: Text(
                                '${AppLocalizations.of(context)!.balanceText}：${client!.item.data}',
                                style: Fontstyle.info(Colors.black54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: screenSize.height * 0.005),
              ListTile(
                title: CustomInputBar(
                  hintText: AppLocalizations.of(context)!.emailText,
                  icon: Icons.email_outlined,
                  controller: emailController,
                  onSubmitted: onSubmitted,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              ListTile(
                title: CustomInputBar(
                  hintText: AppLocalizations.of(context)!.priceText,
                  icon: Icons.money_outlined,
                  controller: storeControlller,
                ),
              ),
            ],
          ),
        ),
        RoundedButton(
          controller: controller,
          icon: Icons.send_outlined,
          text: AppLocalizations.of(context)!.moneyTile,
          onPressed: onPressedSure,
        ),
      ],
    );
  }
}
