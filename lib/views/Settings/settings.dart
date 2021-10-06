import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_manage_app/apis/apis.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/source/source.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/views/views.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:order_manage_app/widgets/widgets.dart';

class SettingsView extends StatefulWidget {
  final void Function()? onPressed;

  const SettingsView({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  UserInfo? currentUser;
  Money? money;
  late bool notice;
  late bool darked;

  @override
  void initState() {
    currentUser = null;
    money = null;
    notice = true;
    darked = false;
    initialState();
    // TODO: implement initState
    super.initState();
  }

  void initialState() async {
    final bool darkinfo = await DarkedSource.initialState();
    setState(() => darked = darkinfo);
    new Timer(new Duration(milliseconds: 500), fetchUserInfo);
    new Timer(new Duration(milliseconds: 1500), fetchMoney);
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

  Money parseMoney(String responseBody) =>
      Money.fromJson(json.decode(responseBody));

  Future fetchMoney() async {
    final response = await http.get(
        Uri.http(APi.bank[0]["url"], APi.bank[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => money = parseMoney(response.body));
  }

  void onChangedNotice(bool? value) => setState(() => notice = value!);

  void onChangedDarked(bool? value) {
    setState(() => darked = value!);
    DarkedSource.settingState(value!);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Module(
      selectedIndex: isMobile ? -1 : 2,
      title: AppLocalizations.of(context)!.settingsTile,
      body: currentUser == null
          ? Responsive(
              mobile: MobileSettingsShimmer(),
              desktop: DesktopSettingsShimmer(),
            )
          : Responsive(
              mobile: MobileSettingsView(
                notice: notice,
                darked: darked,
                onChangedNotice: onChangedNotice,
                onChangedDarked: onChangedDarked,
              ),
              desktop: DesktopSettingsView(
                notice: notice,
                darked: darked,
                onChangedNotice: onChangedNotice,
                onChangedDarked: onChangedDarked,
                money: money,
                userInfo: currentUser,
              ),
            ),
      onPressed: isMobile ? this.widget.onPressed : null,
    );
  }
}

class MobileSettingsView extends StatelessWidget {
  final bool notice;
  final bool darked;
  final void Function(bool? value) onChangedNotice;
  final void Function(bool? value) onChangedDarked;

  const MobileSettingsView({
    Key? key,
    required this.notice,
    required this.darked,
    required this.onChangedNotice,
    required this.onChangedDarked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: ListView(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: Icon(Icons.notifications, size: Parameter.iconSize),
            title: Text(
              AppLocalizations.of(context)!.notificationText,
              style: Fontstyle.device(Colors.black ),
            ),
            trailing: Switch(
              value: notice,
              inactiveTrackColor: Palette.disabledColor,
              inactiveThumbColor: Theme.of(context).primaryColor,
              activeColor: Theme.of(context).primaryColor,
              activeTrackColor: Palette.successColor,
              onChanged: onChangedNotice,
            ),
            onTap: () {},
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: Icon(Icons.dark_mode, size: Parameter.iconSize),
            title: Text(
              AppLocalizations.of(context)!.darkText,
              style: Fontstyle.device(Colors.black ),
            ),
            trailing: Switch(
              value: darked,
              inactiveTrackColor: Palette.disabledColor,
              inactiveThumbColor: Theme.of(context).primaryColor,
              activeColor: Theme.of(context).primaryColor,
              activeTrackColor: Palette.successColor,
              onChanged: onChangedDarked,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class MobileSettingsShimmer extends StatelessWidget {
  const MobileSettingsShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) => shimmerSettings(),
      ),
    );
  }
}

class DesktopSettingsView extends StatelessWidget {
  final bool notice;
  final bool darked;
  final void Function(bool? value) onChangedNotice;
  final void Function(bool? value) onChangedDarked;
  final Money? money;
  final UserInfo? userInfo;

  const DesktopSettingsView({
    Key? key,
    required this.notice,
    required this.darked,
    required this.onChangedNotice,
    required this.onChangedDarked,
    required this.money,
    required this.userInfo,
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
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading:
                            Icon(Icons.notifications, size: Parameter.iconSize),
                        title: Text(
                          AppLocalizations.of(context)!.notificationText,
                          style: Fontstyle.device(Colors.black ),
                        ),
                        trailing: Switch(
                          value: notice,
                          inactiveTrackColor: Palette.disabledColor,
                          inactiveThumbColor: Theme.of(context).primaryColor,
                          activeColor: Theme.of(context).primaryColor,
                          activeTrackColor: Palette.successColor,
                          onChanged: onChangedNotice,
                        ),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading:
                            Icon(Icons.dark_mode, size: Parameter.iconSize),
                        title: Text(
                          AppLocalizations.of(context)!.darkText,
                          style: Fontstyle.device(Colors.black ),
                        ),
                        trailing: Switch(
                          value: darked,
                          inactiveTrackColor: Palette.disabledColor,
                          inactiveThumbColor: Theme.of(context).primaryColor,
                          activeColor: Theme.of(context).primaryColor,
                          activeTrackColor: Palette.successColor,
                          onChanged: onChangedDarked,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                )
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
              child: ProfileList(
                money: money,
                selectedIndex: 1,
                userInfo: userInfo,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DesktopSettingsShimmer extends StatelessWidget {
  const DesktopSettingsShimmer({
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
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) => Row(
                children: [
                  Expanded(child: shimmerSettings()),
                  Expanded(child: shimmerSettings()),
                ],
              ),
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
              child: ProfileLoading(),
            ),
          ),
        ),
      ],
    );
  }
}

Widget shimmerSettings() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Row(
        children: [
          WidgetShimmer.circular(width: 42.0, height: 42.0),
          SizedBox(width: 25.0),
          Expanded(child: WidgetShimmer.rectangular()),
          SizedBox(width: 25.0),
          WidgetShimmer.circular(width: 42.0, height: 42.0),
        ],
      ),
    );
