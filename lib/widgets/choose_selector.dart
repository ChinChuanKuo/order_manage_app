import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/widgets/widgets.dart';

class ChooseSelector extends StatelessWidget {
  final Menu menu;
  final bool showed;
  final void Function(Menu menu) onPressed;

  const ChooseSelector({
    Key? key,
    required this.menu,
    required this.showed,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
          title: Text(
            menu.menu.name,
            style: Fontstyle.subtitle(Colors.black87),
          ),
          subtitle: Text(
            "\$${menu.menu.price}",
            style: Fontstyle.info(Colors.black87),
          ),
          trailing: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "${menu.menu.quantity} 份",
                style: Fontstyle.subtitle(Colors.black87),
              ),
              if (showed) SizedBox(width: screenSize.width * 0.01),
              if (showed)
                CircularButton(
                  icon: Icons.more_horiz_outlined,
                  iconColor: Palette.disabledColor,
                  onPressed: () => onPressed(menu),
                ),
            ],
          ),
        ),
        Divider(color: Palette.dividerColor),
      ],
    );
  }
}
