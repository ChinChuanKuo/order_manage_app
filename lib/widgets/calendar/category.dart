import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CategoryCalendar extends StatelessWidget {
  final CalendarController controller;
  final CalendarDataSource? dataSource;
  final void Function(CalendarLongPressDetails calendarLongPressDetails)?
      onLongPress;
  final void Function(Calendar calendar)? onPressed;

  const CategoryCalendar({
    Key? key,
    required this.controller,
    required this.dataSource,
    this.onLongPress,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      showDatePickerButton: false,
      showNavigationArrow: false,
      view: CalendarView.month,
      selectionDecoration: BoxDecoration(
          border: Border.all(color: Palette.disabledColor, width: 2)),
      todayHighlightColor: Palette.orderColor,
      monthViewSettings:
          MonthViewSettings(showAgenda: true, agendaItemHeight: 60),
      controller: controller,
      loadMoreWidgetBuilder: (BuildContext context,
              Future<void> Function() loadMoreAppointments) =>
          FutureBuilder<void>(
              future: loadMoreAppointments(),
              builder: (BuildContext context, AsyncSnapshot<void> snapShot) =>
                  WidgetLoading().centerCircular),
      appointmentBuilder: (BuildContext context,
          CalendarAppointmentDetails calendarAppointmentDetails) {
        final Calendar calendar = calendarAppointmentDetails.appointments.first;
        return Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              gradient: LinearGradient(colors: Palette.selectedColors)),
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: !calendar.success && !calendar.failed
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            calendar.category.shop.name,
                            style: Fontstyle.subinfo(Colors.black87),
                          ),
                          Text(
                            '${DateFormat('hh:mm a').format(DateTime.parse(calendar.stdate.data))} - ' +
                                '${DateFormat('hh:mm a').format(DateTime.parse(calendar.endate.data))}',
                            style: Fontstyle.subinfo(
                                Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    CircularButton(
                      iconColor: Theme.of(context).primaryColor,
                      icon: Icons.edit_outlined,
                      onPressed: () => onPressed!(calendar),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calendar.category.shop.name,
                      style: Fontstyle.subinfo(Theme.of(context).primaryColor),
                    ),
                    Text(
                      '${DateFormat('hh:mm a').format(DateTime.parse(calendar.stdate.data))} - ' +
                          '${DateFormat('hh:mm a').format(DateTime.parse(calendar.endate.data))}',
                      style: Fontstyle.subinfo(Theme.of(context).primaryColor),
                    ),
                  ],
                ),
        );
      },
      onLongPress: onLongPress,
      dataSource: dataSource,
    );
  }
}
