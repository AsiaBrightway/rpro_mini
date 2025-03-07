import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PrintOrderData extends StatelessWidget {

  Future<void> printOrderData() async {
    // Create a generator for ESC/POS commands
    final generator = Generator(PaperSize.mm80, await CapabilityProfile.load());

    // Generate the order data
    List<int> bytes = [];

    // Header
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
    bytes += generator.setGlobalCodeTable('CP65001');
    bytes += generator.text('မင်္ဂလာပါ');
    // Table Rows
    // for (int i = 0; i < 2; i++) {
    //   bytes += generator.row([
    //     PosColumn(
    //       text: 'ထမင်းကြော်',
    //       width: 4,
    //       styles: const PosStyles(
    //         align: PosAlign.left,
    //         fontType: PosFontType.fontA,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       ),
    //     ),
    //     PosColumn(
    //       text: 'Cup',
    //       width: 2,
    //       styles: const PosStyles(
    //         align: PosAlign.center,
    //         fontType: PosFontType.fontA,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       ),
    //     ),
    //     PosColumn(
    //       text: '1',
    //       width: 2,
    //       styles: const PosStyles(
    //         align: PosAlign.center,
    //         fontType: PosFontType.fontA,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       ),
    //     ),
    //     PosColumn(
    //       text: '',
    //       width: 4,
    //       styles: const PosStyles(
    //         align: PosAlign.right,
    //         fontType: PosFontType.fontA,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       ),
    //     ),
    //   ]);
    // }

    bytes += generator.hr();
    bytes += generator.text('Thank you for your order!', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.cut();

    // Get the printer's IP address
    final printerIp = '192.168.1.87'; // Replace with your printer's IP address

    // Send the data to the printer
    try {
      final socket = await Socket.connect(printerIp, 9100); // Port 9100 is commonly used for network printing
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
        child: ElevatedButton(
          onPressed: printOrderData,
          child: Text('Print Order'),
        ),
      ),
    );
  }
}