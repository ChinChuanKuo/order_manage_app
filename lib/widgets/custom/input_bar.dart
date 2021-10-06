import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';

class CustomInputBar extends StatelessWidget {
  final IconData icon;
  final bool readOnly;
  final String hintText;
  final TextEditingController controller;
  final void Function()? onPressed;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;

  const CustomInputBar({
    Key? key,
    this.icon = Icons.search,
    this.readOnly = false,
    required this.hintText,
    required this.controller,
    this.onPressed,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: new OutlineInputBorder(
            borderRadius: BorderRadius.all(const Radius.circular(24.0)),
            borderSide: BorderSide(style: BorderStyle.none)),
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        hoverColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.only(left: 20.0, right: 12.0),
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(icon),
          iconSize: Parameter.iconSize,
          hoverColor: Colors.transparent,
          color: Palette.disabledColor,
          onPressed: onPressed,
        ),
      ),
      readOnly: readOnly,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
