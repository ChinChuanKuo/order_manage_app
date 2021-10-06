import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShopList extends StatelessWidget {
  final Shop shop;
  final void Function(Category category)? onPressedShop;
  final void Function(Category category)? onPressedStop;
  final void Function(Category category, Menu menu)? onGesture;

  const ShopList({
    Key? key,
    required this.shop,
    required this.onPressedShop,
    required this.onPressedStop,
    required this.onGesture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? MobileShopList(
            shop: shop,
            onPressedShop: onPressedShop,
            onPressedStop: onPressedStop,
            onGesture: onGesture)
        : DesktopShopList(
            shop: shop,
            onPressedShop: onPressedShop,
            onPressedStop: onPressedStop,
            onGesture: onGesture);
  }
}

class MobileShopList extends StatelessWidget {
  final Shop shop;
  final void Function(Category category)? onPressedShop;
  final void Function(Category category)? onPressedStop;
  final void Function(Category category, Menu menu)? onGesture;

  const MobileShopList({
    Key? key,
    required this.shop,
    required this.onPressedShop,
    required this.onPressedStop,
    required this.onGesture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            title: Text(
              shop.category.shop.name,
              style: Fontstyle.header(Colors.black87),
            ),
            trailing: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CircularButton(
                  icon: Icons.add_outlined,
                  iconColor: Palette.disabledColor,
                  onPressed: () => onPressedShop!(shop.category),
                ),
                CircularButton(
                  icon: Icons.delete_outline_outlined,
                  iconColor: Palette.disabledColor,
                  onPressed: () => onPressedStop!(shop.category),
                ),
              ],
            )),
        ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: shop.items.length,
            itemBuilder: (BuildContext context, int index) {
              final Menu menu = shop.items[index];
              return WidgetAnimator(
                vertical: true,
                child: MenuSelector(
                  menu: menu,
                  onGesture: () => onGesture!(shop.category, menu),
                ),
              );
            }),
        Divider(color: Palette.dividerColor),
      ],
    );
  }
}

class DesktopShopList extends StatelessWidget {
  final Shop shop;
  final void Function(Category category)? onPressedShop;
  final void Function(Category category)? onPressedStop;
  final void Function(Category category, Menu menu)? onGesture;
  const DesktopShopList({
    Key? key,
    required this.shop,
    required this.onPressedShop,
    required this.onPressedStop,
    required this.onGesture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
          title: Text(
            shop.category.shop.name,
            style: Fontstyle.header(Colors.black87),
          ),
          trailing: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ColorsButton(
                text: AppLocalizations.of(context)!.addText,
                onPressed: () => onPressedShop!(shop.category),
              ),
              SizedBox(width: screenSize.width * 0.015),
              ColorsButton(
                text: AppLocalizations.of(context)!.deleteText,
                onPressed: () => onPressedStop!(shop.category),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: shop.items.length,
            itemBuilder: (BuildContext context, int index) {
              final Menu menu = shop.items[index];
              return WidgetAnimator(
                vertical: true,
                child: MenuSelector(
                  menu: menu,
                  onGesture: () => onGesture!(shop.category, menu),
                ),
              );
            }),
        Divider(color: Palette.dividerColor),
      ],
    );
  }
}
