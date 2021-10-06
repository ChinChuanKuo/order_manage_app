import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_manage_app/apis/apis.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/source/source.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/views/views.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class CalendarView extends StatefulWidget {
  final void Function()? onPressed;

  const CalendarView({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  UserInfo? currentUser;
  Money? money;
  CalendarSource? dataSource;
  late CalendarController controller;

  @override
  void initState() {
    currentUser = null;
    money = null;
    controller = new CalendarController();
    initialState();
    // TODO: implement initState
    super.initState();
  }

  void initialState() {
    new Timer(new Duration(milliseconds: 500), fetchUserInfo);
    fetchCalendar();
    new Timer(new Duration(milliseconds: 1500), fetchMoney);
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
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

  Future fetchCalendar() async =>
      dataSource = new CalendarSource(calendars: <Calendar>[]);

  void onRestoreMonth(Calendar calendar) => setState(() {
        dataSource!.appointments.addAll(<Calendar>[calendar]);
        dataSource!.notifyListeners(
            CalendarDataSourceAction.add, <Calendar>[calendar]);
      });

  void onLongPressMobile(
      CalendarLongPressDetails calendarLongPressDetails) async {
    if (calendarLongPressDetails.date!.isAfter(DateTime.now())) {
      final TimeOfDay? newTime = await showTimePicker(
          context: context, initialTime: TimeOfDay(hour: 07, minute: 00));
      if (newTime != null)
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0),
            child: CategoryCreate(
              date: calendarLongPressDetails.date,
              time: newTime,
              onRestore: onRestoreMonth,
            ),
          ),
        );
    }
  }

  void onLongPressDesktop(
      CalendarLongPressDetails calendarLongPressDetails) async {
    if (calendarLongPressDetails.date!.isAfter(DateTime.now())) {
      final TimeOfDay? newTime = await showTimePicker(
          context: context, initialTime: TimeOfDay(hour: 07, minute: 00));
      if (newTime != null)
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            elevation: 14.0,
            child: Container(
              width: 352.89,
              height: 434.0,
              child: CategoryCreate(
                date: calendarLongPressDetails.date,
                time: newTime,
                onRestore: onRestoreMonth,
              ),
            ),
          ),
        );
    }
  }

  void onStartupMonth(Calendar calendar) => setState(() {
        dataSource!.appointments.addAll(<Calendar>[calendar]);
        dataSource!.notifyListeners(
            CalendarDataSourceAction.add, <Calendar>[calendar]);
      });

  void onDeletedMonth(Calendar calendar) => setState(() {
        dataSource!.appointments.addAll(<Calendar>[calendar]);
        dataSource!.notifyListeners(
            CalendarDataSourceAction.remove, <Calendar>[calendar]);
      });

  void onPressedMobile(Calendar calendar) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: CategoryOption(
            calendar: calendar,
            datetime: DateTime.parse(calendar.stdate.data),
            onStartup: onStartupMonth,
            onDeleted: onDeletedMonth,
          ),
        ),
      );

  void onPressedDesktop(Calendar calendar) => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: CategoryOption(
              calendar: calendar,
              datetime: DateTime.parse(calendar.stdate.data),
              onStartup: onStartupMonth,
              onDeleted: onDeletedMonth,
            ),
          ),
        ),
      );

  void onPressedMobileSetup() async {
    final DateTime? newDate =
        await showMonthPicker(context: context, initialDate: DateTime.now());
    if (newDate != null)
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: OfficeOption(date: newDate),
        ),
      );
  }

  void onPressedDesktopSetup() async {
    final DateTime? newDate =
        await showMonthPicker(context: context, initialDate: DateTime.now());
    if (newDate != null)
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 434.0,
            child: OfficeOption(date: newDate),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context),
        isDesktop = Responsive.isDesktop(context);
    return Module(
      selectedIndex: isMobile ? -1 : 3,
      title: AppLocalizations.of(context)!.calendarTile,
      body: currentUser == null
          ? Responsive(
              mobile: MobileCalendarShimmer(),
              desktop: DesktopCalendarShimmer(),
            )
          : Responsive(
              mobile: MobileCalendarView(
                controller: controller,
                dataSource: dataSource,
                onLongPress: onLongPressMobile,
                onPressed: onPressedMobile,
              ),
              desktop: DesktopCalendarView(
                money: money,
                controller: controller,
                dataSource: dataSource,
                onLongPress: isDesktop ? onLongPressDesktop : onLongPressMobile,
                onPressed: isDesktop ? onPressedDesktop : onPressedMobile,
                userInfo: currentUser,
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.settings_outlined, color: Palette.disabledColor),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Palette.disabledColor,
        label: Text(AppLocalizations.of(context)!.settingsTile),
        onPressed: isDesktop ? onPressedDesktopSetup : onPressedMobileSetup,
      ),
      onPressed: isMobile ? this.widget.onPressed : null,
    );
  }
}

class MobileCalendarView extends StatelessWidget {
  final CalendarController controller;
  final CalendarDataSource? dataSource;
  final void Function(CalendarLongPressDetails calendarLongPressDetails)?
      onLongPress;
  final void Function(Calendar calendar)? onPressed;

  const MobileCalendarView({
    Key? key,
    required this.controller,
    required this.dataSource,
    required this.onLongPress,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: CategoryCalendar(
        controller: controller,
        dataSource: dataSource,
        onLongPress: onLongPress,
        onPressed: onPressed,
      ),
    );
  }
}

class MobileCalendarShimmer extends StatelessWidget {
  const MobileCalendarShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
        child: WidgetLoading().centerCircular);
  }
}

class DesktopCalendarView extends StatelessWidget {
  final Money? money;
  final CalendarController controller;
  final CalendarDataSource? dataSource;
  final void Function(CalendarLongPressDetails calendarLongPressDetails)?
      onLongPress;
  final void Function(Calendar calendar)? onPressed;

  final UserInfo? userInfo;

  const DesktopCalendarView({
    Key? key,
    required this.money,
    required this.controller,
    required this.dataSource,
    required this.onLongPress,
    required this.onPressed,
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
            child: CategoryCalendar(
              controller: controller,
              dataSource: dataSource,
              onLongPress: onLongPress,
              onPressed: onPressed,
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
                selectedIndex: 2,
                userInfo: userInfo,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DesktopCalendarShimmer extends StatelessWidget {
  const DesktopCalendarShimmer({
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
          margin: const EdgeInsets.only(top: 12.0),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
              child: WidgetLoading().centerCircular),
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
