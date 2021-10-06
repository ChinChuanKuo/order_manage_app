import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
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

class OfficeOption extends StatefulWidget {
  final DateTime date;

  const OfficeOption({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  _OfficeOptionState createState() => _OfficeOptionState();
}

class _OfficeOptionState extends State<OfficeOption> {
  List<Office>? offices;
  late RoundedLoadingButtonController controller;
  late RoundedLoadingButtonController sureController;

  @override
  void initState() {
    offices = <Office>[];
    controller = new RoundedLoadingButtonController();
    sureController = new RoundedLoadingButtonController();
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
      new Timer(new Duration(milliseconds: 1500), fetchClients);

  List<Office> parseClients(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Office>((data) => Office.fromJson(data)).toList();
  }

  Future fetchClients() async {
    final response = await http.get(
        Uri.http(APi.office[0]["url"], APi.office[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
          "datainfo": json.encode(DataSource.initialState(
              "${this.widget.date.year}/${this.widget.date.month}/${this.widget.date.day}")),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => offices = parseClients(response.body));
  }

  void onPressedCancel() => Navigator.pop(context);

  Office newOffice() => new Office(
      item: new DataJson(data: ''),
      client: new ClientJson(email: '', clientid: '', accesstoken: ''),
      action: new ActionJson(inserted: true, modified: false, deleted: false));

  void onPressedPlus() {
    setState(() => offices!.insert(0, newOffice()));
    controller.reset();
  }

  Office parseOffice(String responseBody) =>
      Office.fromJson(json.decode(responseBody));

  void onSubmitted(String value, int index) async {
    if (value.isNotEmpty) {
      final response = await http.post(
          Uri.http(
            APi.office[1]["url"],
            APi.office[1]["route"],
          ),
          body: {
            "clientinfo": json.encode(await ClientSource.initialState()),
            "deviceinfo": json.encode(await DeviceSource.initialState()),
            "datainfo": json.encode(DataSource.initialState(
                "${this.widget.date.year}/${this.widget.date.month}/${this.widget.date.day}")),
            "infotext": value,
          },
          headers: {
            "Accept": "application/json"
          });
      if (response.statusCode == 200)
        setState(() => offices![index] = parseOffice(response.body));
    }
  }

  void onPressedDelete(int index) async {
    if (offices![index].action.deleted) {
      final response = await http
          .post(Uri.http(APi.office[3]["url"], APi.office[3]["route"]), body: {
        "clientinfo": json.encode(await ClientSource.initialState()),
        "deviceinfo": json.encode(await DeviceSource.initialState()),
        "notherinfo":
            json.encode(ClientJson.initialState(offices![index].client)),
        "datainfo": json.encode(DataSource.initialState(
            "${this.widget.date.year}/${this.widget.date.month}/${this.widget.date.day}")),
      }, headers: {
        "Accept": "application/json"
      });
      final statusCode = response.statusCode == 200;
      if (statusCode) setState(() => offices!.removeAt(index));
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
    } else
      setState(() => offices!.removeAt(index));
  }

  void onPressedSure() async {
    final officeinfo = offices!.where((client) => client.action.modified);
    final response = await http
        .post(Uri.http(APi.office[2]["url"], APi.office[2]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
      "officeinfo": json.encode(OfficeSource.initialState(officeinfo)),
      "datainfo": json.encode(DataSource.initialState(
          "${this.widget.date.year}/${this.widget.date.month}/${this.widget.date.day}")),
    }, headers: {
      "Accept": "application/json"
    });
    final statusCode = response.statusCode == 200;
    if (statusCode) Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool showSure =
        offices!.where((client) => client.action.modified).length > 0;
    return Column(
      children: [
        SheetTile(
          onCancel: onPressedCancel,
          title:
              '${DateFormat('MM').format(this.widget.date)} ${AppLocalizations.of(context)!.monthText} ${AppLocalizations.of(context)!.officeText}',
          showed: true,
          text: AppLocalizations.of(context)!.addText,
          controller: controller,
          onPressed: onPressedPlus,
        ),
        SizedBox(height: screenSize.height * 0.01),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: offices!.length,
            itemBuilder: (BuildContext context, int index) {
              final Office office = offices![index];
              return WidgetAnimator(
                vertical: true,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  title: CustomInputBar(
                    hintText: AppLocalizations.of(context)!.emailText,
                    icon: Icons.email_outlined,
                    controller: new TextEditingController()
                      ..text = office.item.data,
                    readOnly: office.action.deleted,
                    onSubmitted: (String value) => onSubmitted(value, index),
                  ),
                  subtitle: Text(
                    office.client.email,
                    style: Fontstyle.device(Colors.black ),
                  ),
                  trailing: CircularButton(
                    icon: Icons.remove_outlined,
                    iconColor: Palette.disabledColor,
                    onPressed: () => onPressedDelete(index),
                  ),
                ),
              );
            },
          ),
        ),
        if (showSure)
          RoundedButton(
            controller: sureController,
            icon: Icons.send_outlined,
            text: AppLocalizations.of(context)!.sureText,
            onPressed: onPressedSure,
          ),
      ],
    );
  }
}
