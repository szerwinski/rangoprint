import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rangoprint/rangoprint.dart';
import 'package:rangoprint/size.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:path_provider/path_provider.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _rangoprintPlugin = Rangoprint();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _rangoprintPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }


  Uint8List textToImageBytes(String text) {
    // Create an image with the specified text
    img.Image image = img.Image(width: 200,height: 100); // Width and height of the image

    // Encode the image into a byte array (PNG format in this example)
    List<int> pngBytes = img.encodePng(image);

    // Convert the list of integers to a Uint8List
    Uint8List uint8List = Uint8List.fromList(pngBytes);

    return uint8List;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            ElevatedButton(
              onPressed: () async {
                var doc = pw.Document();
                doc.addPage(pw.Page(
                  build: (context) => pw.Text("Hello World"),
                ));
                await for (var page in Printing.raster(await doc.save(), pages: [0], dpi: 72)) {
                  final image = await page.toImage(); // ...or page.toPng()
                  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
                  if (byteData != null) {
                    Uint8List pngBytes = byteData.buffer.asUint8List();
                    await _rangoprintPlugin.printBitmap(pngBytes);
                  }
                }
              },
              child: const Text("_print"),
            )
          ],
        ),
      ),
    );
  }
}
