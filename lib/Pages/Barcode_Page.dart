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
  TextEditingController _isbnController = TextEditingController();
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
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookDetailsPage(isbn: barcodeScanRes),
        ),
      ).then((value) {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Error: Please scan again or input ISBN no.'),
              ),
              backgroundColor: Colors.indigo,
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Error: Please scan again or input ISBN no.'),
          ),
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 160,
              ),
              CachedNetworkImage(
                imageUrl:
                    'https://media.tenor.com/8E3SIU76kHgAAAAC/barcode-scan.gif',
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                onPressed: _scanBarcode,
                child: const Text('Start Barcode scan'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Search ISBN No.'),
                        content: TextField(
                          controller: _isbnController,
                          decoration: const InputDecoration(
                            hintText: 'Enter ISBN No.',
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              String isbn = _isbnController.text.trim();
                              navigateToBookDetailsPage(isbn);
                            },
                            child: const Text('Search'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Search ISBN No.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
