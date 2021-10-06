import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_manage_app/apis/apis.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/source/source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarSource extends CalendarDataSource {
  final List<Calendar> calendars;

  CalendarSource({required this.calendars});

  @override
  List<dynamic> get appointments => calendars;

  @override
  DateTime getStartTime(int index) =>
      DateTime.parse(calendars[index].stdate.data);

  @override
  DateTime getEndTime(int index) =>
      DateTime.parse(calendars[index].endate.data);

  @override
  bool isAllDay(int index) => false;

  @override
  Color getColor(int index) => calendars[index].success
      ? Palette.successColor
      : calendars[index].failed
          ? Palette.failedColor
          : Palette.warnColor;

  List<Calendar> parseCalendars(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Calendar>((data) => Calendar.fromJson(data)).toList();
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    final response = await http.get(
        Uri.http(APi.calendar[0]["url"], APi.calendar[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
          "dateinfo": json.encode(DateSource.initialState(
              "${startDate.year}/${startDate.month}/${startDate.day}",
              "${endDate.year}/${endDate.month}/${endDate.day}")),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      final List<Calendar> items = <Calendar>[];
      final calendarBody = parseCalendars(response.body);
      for (final Calendar calendar in calendarBody)
        if (calendars.indexWhere((element) =>
                element.category.requireid.orderid ==
                calendar.category.requireid.orderid) ==
            -1) items.add(calendar);
      appointments.addAll(items);
      notifyListeners(CalendarDataSourceAction.add, items);
    }
  }
}
