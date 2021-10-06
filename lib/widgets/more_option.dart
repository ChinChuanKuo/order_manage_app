import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/widgets/widgets.dart';

class MoreOption extends StatefulWidget {
  final Menu? menu;
  final void Function(Menu menu)? onIncrease;
  final void Function(Menu menu)? onSoldout;

  const MoreOption({
    Key? key,
    required this.menu,
    required this.onIncrease,
    required this.onSoldout,
  }) : super(key: key);

  @override
  _MoreOptionState createState() => _MoreOptionState();
}

class _MoreOptionState extends State<MoreOption> {
  Menu? menu;

  @override
  void initState() {
    menu = this.widget.menu;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void onPressedCancel() => Navigator.pop(context);

  void onTapIncrease() {
    Navigator.pop(context);
    this.widget.onIncrease!(menu!);
  }

  void onTapSoldout() {
    Navigator.pop(context);
    this.widget.onSoldout!(menu!);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SheetTile(
          onCancel: onPressedCancel,
          title: menu!.menu.name,
          showed: false,
        ),
        SizedBox(height: screenSize.height * 0.01),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  title: Text(
                    '漲價',
                    style: Fontstyle.subtitle(Colors.black87),
                  ),
                  onTap: onTapIncrease,
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  title: Text(
                    '售罄',
                    style: Fontstyle.subtitle(Colors.black87),
                  ),
                  onTap: onTapSoldout,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
