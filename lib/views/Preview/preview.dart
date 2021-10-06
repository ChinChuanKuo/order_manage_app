import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_manage_app/views/views.dart';
import 'package:order_manage_app/models/models.dart';
import 'package:order_manage_app/apis/apis.dart';
import 'package:order_manage_app/source/source.dart';
import 'package:order_manage_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreviewView extends StatefulWidget {
  final Category? category;

  const PreviewView({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  _PreviewViewState createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  UserInfo? currentUser;
  Preview? preview;
  Total? total;

  @override
  void initState() {
    currentUser = null;
    preview = null;
    total = null;
    initialState();
    // TODO: implement initState
    super.initState();
  }

  void initialState() {
    new Timer(new Duration(milliseconds: 500), fetchUserInfo);
    new Timer(new Duration(milliseconds: 1500), fetchPreview);
    new Timer(new Duration(milliseconds: 2500), fetchTotal);
  }

  UserInfo parseInfo(String responseBody) =>
      UserInfo.fromJson(json.decode(responseBody));

  Future fetchUserInfo() async {
    final response = await http.get(
        Uri.http(APi.user[0]["url"], APi.user[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => currentUser = parseInfo(response.body));
  }

  Preview parseReview(String responseBody) =>
      Preview.fromJson(json.decode(responseBody));

  Future fetchPreview() async {
    final response = await http.get(
        Uri.http(APi.preview[0]["url"], APi.preview[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => preview = parseReview(response.body));
  }

  Total parseTotal(String responseBody) =>
      Total.fromJson(json.decode(responseBody));

  Future fetchTotal() async {
    final response = await http.get(
        Uri.http(APi.preview[1]["url"], APi.preview[1]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => total = parseTotal(response.body));
  }

  void onPressed() => Navigator.pop(context);

  Future<Uint8List> reviewPDF() async {
    final doc = pw.Document();
    final imageByte = pw.MemoryImage(
        (await rootBundle.load('images/logo.png')).buffer.asUint8List());
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle.load("fonts/black.ttf")),
          bold: pw.Font.ttf(await rootBundle.load("fonts/black.ttf")),
          italic: pw.Font.ttf(await rootBundle.load("fonts/black.ttf")),
          boldItalic: pw.Font.ttf(await rootBundle.load("fonts/black.ttf")),
        ),
        header: (pw.Context context) => reviewHeader(context, imageByte),
        build: (pw.Context context) => [
          contentHeader(),
          contentTable(),
          pw.Divider(),
          pw.SizedBox(height: 8.0),
          totalTable(),
        ],
      ),
    );
    return doc.save();
  }

  pw.Widget reviewHeader(pw.Context pwContext, dynamic imageByte) => pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    this.widget.category!.shop.name,
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#fa792f"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 32.0),
                  ),
                  pw.SizedBox(height: 12.0),
                  pw.Text(
                    "${AppLocalizations.of(context)!.phoneText.toUpperCase()}:${this.widget.category!.shop.phone}",
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#383050"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14.0),
                  ),
                  pw.SizedBox(height: 6.0),
                  pw.Text(
                    '${AppLocalizations.of(context)!.addressText.toUpperCase()}:${this.widget.category!.shop.address}',
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#383050"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14.0),
                  ),
                ],
              ),
              pw.Image(imageByte, height: 45.0),
            ],
          ),
          pw.SizedBox(height: 12.0),
        ],
      );

  pw.Widget contentHeader() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "${AppLocalizations.of(context)!.totalText}:\$${totalPrice(total!.items)}",
            style: pw.TextStyle(
                color: PdfColor.fromHex("#fa792f"),
                fontWeight: pw.FontWeight.bold,
                fontStyle: pw.FontStyle.italic,
                fontSize: 16.5),
          ),
          pw.SizedBox(height: 16.0),
        ],
      );

  int totalPrice(List<Menu> orders) {
    int result = 0;
    for (var order in orders) {
      result += int.parse(order.menu.price) * int.parse(order.menu.quantity);
    }
    return result;
  }

  pw.Widget contentTable() => pw.Table.fromTextArray(
        border: null,
        headerDecoration: pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            color: PdfColor.fromHex("#fa792f")),
        headerHeight: 25.0,
        cellHeight: 40.0,
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerLeft,
          3: pw.Alignment.centerLeft,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
        ),
        headers: List<String>.generate(
          preview!.item.length,
          (col) => preview!.item[col].data,
        ),
        data: List<List<String>>.generate(
          preview!.items.length,
          (row) => List<String>.generate(
            preview!.item.length,
            (col) => orderitem(preview!.items[row], col),
          ),
        ),
      );

  String orderitem(Order order, int index) {
    switch (index) {
      case 0:
        return order.client.email;
      case 1:
        return order.menu.menu.name;
      case 2:
        return order.menu.menu.quantity;
    }
    return "\$${order.menu.menu.price}";
  }

  pw.Widget totalTable() => pw.Table.fromTextArray(
        border: null,
        headerDecoration: pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            color: PdfColor.fromHex("#fa792f")),
        headerHeight: 25.0,
        cellHeight: 40.0,
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerLeft,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
        ),
        headers: List<String>.generate(
          total!.item.length,
          (col) => total!.item[col].data,
        ),
        data: List<List<String>>.generate(
          total!.items.length,
          (row) => List<String>.generate(
            total!.item.length,
            (col) => menuitem(total!.items[row], col),
          ),
        ),
      );

  String menuitem(Menu menu, int index) {
    switch (index) {
      case 0:
        return menu.menu.name;
      case 1:
        return '${menu.menu.quantity} x \$${menu.menu.price}';
    }
    return '\$${int.parse(menu.menu.price) * int.parse(menu.menu.quantity)}';
  }

  @override
  Widget build(BuildContext context) {
    return Module(
      selectedIndex: -1,
      title: AppLocalizations.of(context)!.previewTile,
      body: total == null
          ? WidgetLoading().centerCircular
          : PdfPreview(
              build: (PdfPageFormat format) => reviewPDF(),
            ),
      onPressed: onPressed,
    );
  }
}
