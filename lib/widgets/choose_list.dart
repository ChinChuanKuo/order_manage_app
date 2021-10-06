import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:order_manage_app/widgets/widgets.dart';

class ChooseList extends StatelessWidget {
  final Choose choose;
  final void Function(Menu menu) onPressed;

  const ChooseList({
    Key? key,
    required this.choose,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool showChoose = choose.shop.items.length == 0;
    return Container(
      width: 280.0,
      constraints: BoxConstraints(maxWidth: 280.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: showChoose
                ? Text(
                    "My ${AppLocalizations.of(context)!.shopText}",
                    style: Fontstyle.header(Palette.orderColor),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        choose.shop.category.shop.name,
                        style: Fontstyle.header(Palette.orderColor),
                      ),
                      Text(
                        "${choose.opened ? AppLocalizations.of(context)!.businessText : choose.closed ? AppLocalizations.of(context)!.closedText : AppLocalizations.of(context)!.waitedText}：${choose.time.data}",
                        style: Fontstyle.subtitle(Colors.black54),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: showChoose ? screenSize.height * 0.03 : 0.0),
          Expanded(
            child: showChoose
                ? Text(
                    AppLocalizations.of(context)!.dontMessageText,
                    style: Fontstyle.info(Colors.black54),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: choose.shop.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Menu menu = choose.shop.items[index];
                      return WidgetAnimator(
                        vertical: true,
                        child: ChooseSelector(
                          menu: menu,
                          showed: !choose.opened && choose.closed,
                          onPressed: onPressed,
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: Parameter.bottomHeight),
        ],
      ),
    );
  }
}
