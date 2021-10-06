import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';

class ColorsButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const ColorsButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        child: Ink(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: Palette.selectedColors),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Text(
              this.text,
              style: Fontstyle.info(Palette.orderColor),
            ),
          ),
        ),
        onPressed: onPressed);
  }
}
