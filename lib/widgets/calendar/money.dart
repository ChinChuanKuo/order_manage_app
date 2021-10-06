import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MoneyCalendar extends StatelessWidget {
  final CalendarController controller;
  final CalendarDataSource? dataSource;
  final void Function(CalendarLongPressDetails calendarLongPressDetails)?
      onLongPress;
  final void Function(Store store)? onPressed;

  const MoneyCalendar({
    Key? key,
    required this.controller,
    required this.dataSource,
    this.onLongPress,
    this.onPressed,
  }) : super(key: key);

  String getMonthDate(int month) => [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ][month - 1];

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      showNavigationArrow: false,
      showDatePickerButton: false,
      view: CalendarView.schedule,
      backgroundColor: Colors.transparent,
      todayHighlightColor: Palette.orderColor,
      scheduleViewMonthHeaderBuilder:
          (BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
        final String monthTile = getMonthDate(details.date.month);
        return Stack(
          children: [
            Image(
              image: ExactAssetImage('images/$monthTile.png'),
              fit: BoxFit.cover,
              width: details.bounds.width,
              height: details.bounds.height,
            ),
            Positioned(
              left: 55,
              right: 0,
              top: 20,
              bottom: 0,
              child: Text(
                '$monthTile ${details.date.year}',
                style: Fontstyle.header(Colors.black87),
              ),
            ),
          ],
        );
      },
      controller: controller,
      loadMoreWidgetBuilder: (BuildContext context,
              Future<void> Function() loadMoreAppointments) =>
          FutureBuilder<void>(
              future: loadMoreAppointments(),
              builder: (BuildContext context, AsyncSnapshot<void> snapShot) =>
                  WidgetLoading().centerCircular),
      appointmentBuilder: (BuildContext context,
          CalendarAppointmentDetails calendarAppointmentDetails) {
        final Store store = calendarAppointmentDetails.appointments.first;
        return GestureDetector(
          onTap: () => onPressed!(store),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            decoration: BoxDecoration(
              color: store.success
                  ? Palette.successColor
                  : store.failed
                      ? Palette.failedColor
                      : Palette.warnColor,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.totalText}：\$${store.store.store}',
                      style: Fontstyle.subinfo(Theme.of(context).primaryColor),
                    ),
                    Text(
                      store.store.category,
                      style: Fontstyle.subinfo(Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                Text(
                  '${DateFormat('hh:mm a').format(DateTime.parse(store.stdate.data))} - ' +
                      '${DateFormat('hh:mm a').format(DateTime.parse(store.endate.data))}',
                  style: Fontstyle.subinfo(Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        );
      },
      scheduleViewSettings: ScheduleViewSettings(appointmentItemHeight: 60.0),
      onLongPress: onLongPress,
      dataSource: dataSource,
    );
  }
}
