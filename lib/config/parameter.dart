import 'package:flutter/material.dart';
import 'package:order_manage_app/widgets/widgets.dart';

class Parameter {
  static final double bottomHeight = Responsive.isDevice() ? 75.0 : 65.0;
  static final EdgeInsetsGeometry bottomPadding = Responsive.isDevice()
      ? const EdgeInsets.only(bottom: 22.0)
      : const EdgeInsets.only(bottom: 12.0);
  static final double iconSize = Responsive.isDevice() ? 26.5 : 25.0;
  static final double textSize = Responsive.isDevice() ? 13.5 : 15.0;
}
