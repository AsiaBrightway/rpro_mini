import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart'; // For image manipulation

class PrintUnicodeWidget extends StatelessWidget {
  final WidgetsToImageController widgetsToImageController = WidgetsToImageController();

  Future<void> printOrderData() async {
    // Capture the Myanmar text as an image
    final Uint8List? imageBytes = await widgetsToImageController.capture();
    if (imageBytes == null) {
      print('Failed to capture image');
      return;
    }

    // Decode the image
    final image = decodeImage(imageBytes)!;

    // Create a generator for ESC/POS commands
    final generator = Generator(PaperSize.mm58, await CapabilityProfile.load());

    // Generate the receipt using ESC/POS commands
    List<int> bytes = [];
    bytes += generator.text(
      'INNOCENT',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.text(
      '(Bar and Refrigerator Orders)',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.text('2025-02-20, 2:49 PM (700)');
    bytes += generator.text('G-Floor, B4, 1');
    bytes += generator.hr();

    // Table Header
    bytes += generator.row([
      PosColumn(
        text: 'Name',
        width: 4,
        styles: const PosStyles(
          align: PosAlign.left,
          fontType: PosFontType.fontA,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: 'Unit',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.center,
          fontType: PosFontType.fontA,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: 'Qty',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.center,
          fontType: PosFontType.fontA,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: 'Remark',
        width: 4,
        styles: const PosStyles(
          align: PosAlign.right,
          fontType: PosFontType.fontA,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
    ]);

    // Add the Myanmar text as an image
    bytes += generator.image(image);

    // Table Rows (other data)
    for (int i = 0; i < 2; i++) {
      bytes += generator.row([
        PosColumn(
          text: 'Item ${i + 1}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: 'Cup',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: '1',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: '',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
      ]);
    }

    bytes += generator.hr();
    bytes += generator.cut();

    // Send the ESC/POS commands to the network printer
    await sendToNetworkPrinter(bytes);
  }

  Future<void> sendToNetworkPrinter(List<int> bytes) async {
    // Replace with your printer's IP address and port
    const String printerIp = '192.168.1.87'; // Printer IP address
    const int printerPort = 9100; // Default port for network printing

    try {
      // Connect to the printer
      final Socket socket = await Socket.connect(printerIp, printerPort);

      // Send the ESC/POS commands to the printer
      socket.add(bytes);
      await socket.flush();
      await socket.close();

      print('Printing successful!');
    } catch (e) {
      print('Error printing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print Order Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetsToImage(
              controller: widgetsToImageController,
              child: const Text(
                'ထမင်းကြော်', // Myanmar text
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: printOrderData,
              child: Text('Print Order'),
            ),
          ],
        ),
      ),
    );
  }
}