import 'package:flutter/material.dart';
import 'package:order_manage_app/config/config.dart';
import 'package:order_manage_app/widgets/widgets.dart';

class OrderLoading extends StatelessWidget {
  const OrderLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: WidgetShimmer.rectangular(width: 50.0),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) => orderloading(),
            ),
          ),
          SizedBox(height: Parameter.bottomHeight),
        ],
      ),
    );
  }

  Widget orderloading() => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
        title: WidgetShimmer.rectangular(),
        trailing: WidgetShimmer.circular(width: 42.0, height: 42.0),
      );
}
