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

class SuggestOption extends StatefulWidget {
  final void Function(Category category)? onCreate;

  const SuggestOption({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  _SuggestOptionState createState() => _SuggestOptionState();
}

class _SuggestOptionState extends State<SuggestOption> {
  List<Suggest>? suggests;

  @override
  void initState() {
    suggests = null;
    initialState();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initialState() =>
      new Timer(new Duration(milliseconds: 1500), fetchSuggests);

  List<Suggest> parseSuggests(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Suggest>((data) => Suggest.fromJson(data)).toList();
  }

  Future fetchSuggests() async {
    final response = await http.get(
        Uri.http(APi.suggest[0]["url"], APi.suggest[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => suggests = parseSuggests(response.body));
  }

  void onPressedCancel() => Navigator.pop(context);

  Category parseCategory(String responseBody) =>
      Category.fromJson(json.decode(responseBody));

  void onPressedSure(Suggest suggest) async {
    setState(() => suggests!.remove(suggest));
    final response = await http
        .post(Uri.http(APi.suggest[1]["url"], APi.suggest[1]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
      "requiredinfo":
          json.encode(RequireidJson.initialState(suggest.category.requireid)),
    }, headers: {
      "Accept": "application/json"
    });
    final statusCode = response.statusCode == 200;
    if (statusCode) this.widget.onCreate!(parseCategory(response.body));
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

  void onPressedRemove(Suggest suggest) async {
    setState(() => suggests!.remove(suggest));
    final response = await http
        .post(Uri.http(APi.suggest[2]["url"], APi.suggest[2]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
      "requiredinfo":
          json.encode(RequireidJson.initialState(suggest.category.requireid)),
    }, headers: {
      "Accept": "application/json"
    });
    final statusCode = response.statusCode == 200;
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
    return Column(
      children: [
        SheetTile(
          onCancel: onPressedCancel,
          title:
              '${AppLocalizations.of(context)!.suggestTile} ${AppLocalizations.of(context)!.shopText}',
        ),
        SizedBox(height: screenSize.height * 0.01),
        Expanded(
          child: suggests == null
              ? WidgetLoading().centerCircular
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: suggests!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Suggest suggest = suggests![index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      title: Text(
                        suggest.category.shop.name,
                        style: Fontstyle.device(Colors.black ),
                      ),
                      subtitle: Text(
                        suggest.category.shop.address,
                        style: Fontstyle.device(Colors.black ),
                      ),
                      trailing: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          CircularButton(
                            icon: Icons.check_outlined,
                            iconColor: Palette.disabledColor,
                            onPressed: () => onPressedSure(suggest),
                          ),
                          SizedBox(width: screenSize.width * 0.025),
                          CircularButton(
                            icon: Icons.remove_outlined,
                            iconColor: Palette.disabledColor,
                            onPressed: () => onPressedRemove(suggest),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
