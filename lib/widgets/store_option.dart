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

class StoreOption extends StatefulWidget {
  final Store? store;

  const StoreOption({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  _StoreOptionState createState() => _StoreOptionState();
}

class _StoreOptionState extends State<StoreOption> {
  List<Balance>? balances;

  @override
  void initState() {
    balances = null;
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
      new Timer(new Duration(milliseconds: 1500), fetchBalances);

  List<Balance> parseBalances(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Balance>((data) => Balance.fromJson(data)).toList();
  }

  Future fetchBalances() async {
    final response = await http
        .post(Uri.http(APi.bank[4]["url"], APi.bank[4]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
      "requiredinfo":
          json.encode(RequireidJson.initialState(this.widget.store!.requireid)),
      "datainfo": json
          .encode(DataSource.initialState(this.widget.store!.store.category)),
      "dateinfo":
          json.encode(DataSource.initialState(this.widget.store!.stdate.data))
    }, headers: {
      "Accept": "application/json"
    });
    if (response.statusCode == 200)
      setState(() => balances = parseBalances(response.body));
  }

  void onPressedCancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SheetTile(
          onCancel: onPressedCancel,
          title: this.widget.store!.store.category,
        ),
        SizedBox(height: screenSize.height * 0.01),
        Expanded(
          child: balances == null
              ? WidgetLoading().centerCircular
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: balances!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Balance balance = balances![index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical:
                              balance.store.category.isNotEmpty ? 12.0 : 18.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          balance.store.category.isNotEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${balance.client.email}：\$${balance.store.store}',
                                      style: Fontstyle.subtitle(Colors.black87),
                                    ),
                                    Text(
                                      balance.store.category,
                                      style:
                                          Fontstyle.info(Palette.disabledColor),
                                    ),
                                  ],
                                )
                              : Text(
                                  '${balance.client.email}：\$${balance.store.store}',
                                  style: Fontstyle.subtitle(Colors.black87),
                                ),
                          Text(
                            balance.time.data,
                            style: Fontstyle.subinfo(Colors.black87),
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
