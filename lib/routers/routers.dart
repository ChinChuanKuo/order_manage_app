import 'package:flutter/material.dart';
import 'package:order_manage_app/views/views.dart';

class Routers {
  late SigninView signinRoute;
  late HomeView homeRoute;
  late MoneyView moneyRoute;
  late SettingsView settingsRoute;
  //late HistoryView historyRoute;
  late ProfileView profileRoute;
  late PersonalView personalRoute;
  late CalendarView calendarRoute;
  late PreviewView previewRoute;
}

abstract class Routes {
  static const signinRoute = "/signin";
  static const homeRoute = "/";
  static const moneyRoute = "/money";
  static const settingsRoute = "/settings";
  //static const historyRoute = "/history";
  static const profileRoute = "/profile";
  static const personalRoute = "/personal";
  static const calendarRoute = "/calendar";
  static const previewRoute = "/preview";
}

class RouterGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.signinRoute:
        return MaterialPageRoute(
          builder: (_) => SigninView(),
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (_) => HomeView(),
        );
      case Routes.moneyRoute:
        return MaterialPageRoute(
          builder: (_) => MoneyView(),
        );
      case Routes.settingsRoute:
        return MaterialPageRoute(
          builder: (_) => SettingsView(),
        );
      /*case Routes.historyRoute:
        return MaterialPageRoute(
          builder: (_) => HistoryView(),
        );*/
      case Routes.profileRoute:
        return MaterialPageRoute(
          builder: (_) => ProfileView(),
        );
      case Routes.personalRoute:
        return MaterialPageRoute(
          builder: (_) => PersonalView(),
        );
      case Routes.calendarRoute:
        return MaterialPageRoute(
          builder: (_) => CalendarView(),
        );
      case Routes.previewRoute:
        return MaterialPageRoute(
          builder: (_) => PreviewView(),
        );
    }
    return MaterialPageRoute(
      builder: (_) => WrongView(name: settings.name),
    );
  }
}
