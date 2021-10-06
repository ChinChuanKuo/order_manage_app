import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/config/palette.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuSelector extends StatelessWidget {
  final Menu menu;
  final void Function()? onGesture;

  const MenuSelector({
    Key? key,
    required this.menu,
    required this.onGesture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? MobileMenuSelector(menu: menu, onGesture: onGesture)
        : DesktopMenuSelector(menu: menu, onGesture: onGesture);
  }
}

class MobileMenuSelector extends StatelessWidget {
  final Menu menu;
  final void Function()? onGesture;

  const MobileMenuSelector({
    Key? key,
    required this.menu,
    required this.onGesture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            menu.menu.name,
            style: Fontstyle.subtitle(Colors.black87),
          ),
          subtitle: Text(
            "\$${menu.menu.price}",
            style: Fontstyle.subtitle(Colors.black87),
          ),
          trailing: CircularButton(
            icon: Icons.edit_outlined,
            iconColor: Palette.disabledColor,
            onPressed: onGesture,
          ),
        ),
      ],
    );
  }
}

class DesktopMenuSelector extends StatelessWidget {
  final Menu menu;
  final void Function()? onGesture;

  const DesktopMenuSelector({
    Key? key,
    required this.menu,
    required this.onGesture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
          title: Text(
            menu.menu.name,
            style: Fontstyle.subtitle(Colors.black87),
          ),
          trailing: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "\$${menu.menu.price}",
                style: Fontstyle.subtitle(Colors.black87),
              ),
              SizedBox(width: screenSize.width * 0.03),
              ColorsButton(
                text: AppLocalizations.of(context)!.setupText,
                onPressed: onGesture,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
