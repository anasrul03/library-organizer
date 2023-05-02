import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'BookDetails_Page.dart';

class BarcodePage extends StatefulWidget {
  const BarcodePage({Key? key}) : super(key: key);

  @override
  BarcodePageState createState() => BarcodePageState();
}

class BarcodePageState extends State<BarcodePage> {
  String barcode = '';
  String bookTitle = '';
  String bookDescription = '';
  String bookImage = '';
  String scanBarcode = 'Unknown';

  Future<void> navigateToBookDetailsPage(String isbn) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(isbn: isbn),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scanBarcode();
    setState(() {});
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
    } on Exception {
      barcodeScanRes = 'Failed to get barcode';
    }

    if (!mounted) return;

    setState(() {
      scanBarcode = barcodeScanRes;
    });

    if (barcodeScanRes != '-1') {
      await navigateToBookDetailsPage(barcodeScanRes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Spacer(),
          CachedNetworkImage(
              imageUrl:
                  'https://media.tenor.com/8E3SIU76kHgAAAAC/barcode-scan.gif'),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: _scanBarcode,
            child: const Text('Start Barcode scan'),
          ),
          const ElevatedButton(
            onPressed: null,
            child: Text('Search ISBN No.'),
          ),
          const Spacer()
        ],
      )),
    );
  }
}
