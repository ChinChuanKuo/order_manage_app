import 'package:order_manage_app/config/config.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final Color? boxColor;
  final EdgeInsetsGeometry padding;
  final IconData icon;
  final Color? iconColor;
  final void Function()? onPressed;

  const CircularButton({
    Key? key,
    this.margin = const EdgeInsets.all(3.0),
    this.boxColor = Colors.transparent,
    this.padding = const EdgeInsets.all(8.0),
    required this.icon,
    this.iconColor = Colors.black,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: this.boxColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: padding,
        icon: Icon(this.icon),
        iconSize: Parameter.iconSize,
        hoverColor: Colors.transparent,
        color: this.iconColor,
        onPressed: this.onPressed,
      ),
    );
  }
}
