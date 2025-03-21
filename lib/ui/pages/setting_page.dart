
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/vos/item_vo.dart';
import 'package:rpro_mini/data/vos/printer_config.dart';
import 'package:rpro_mini/ui/components/screenshot_widget.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/bluetooth_service.dart';
import '../../utils/helper_functions.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<ItemVo> orderItems = [
    ItemVo(1, 1, 6, 3, "itemCode", "barCode", "ဝက်နံရိုးဟင်းရည် ဝက်သား", "", "", "", "", "8000", "700"),
    ItemVo(2, 2, 6, 3, "itemCode", "barCode", "corn dog", "", "", "", "", "7000", "700"),
    ItemVo(3, 2, 5, 3, "itemCode", "barCode", "တောက်တောက်ကြော်", "", "", "", "", "5000", "700"),
  ];

  String formattedDateTime = DateFormat('yyyy-MM-dd h:mm:ss a').format(DateTime.now());
  ScreenshotController screenshotControllerBar = ScreenshotController();
  ScreenshotController screenshotControllerKitchen = ScreenshotController();
  ScreenshotController screenshotControllerBBQ = ScreenshotController();
  ScreenshotController screenshotControllerCounter = ScreenshotController();

  Uint8List? theBarImage; //3
  Uint8List? theKitchenImage; //1
  Uint8List? theBBQImage; //2
  Uint8List? theCounterImage; //4

  PrinterService? _printerService;
  List<PrinterConfig> printers = [];

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    _loadPrinterConfig();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printerService = context.read<PrinterService>();
      _printerService?.getPairedDevices();
    });
  }

  Future<void> _loadPrinterConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? printerList = prefs.getStringList('printer_config');

    if (printerList != null) {
      setState(() {
        printers = printerList.map((p) => PrinterConfig.fromJson(jsonDecode(p))).toList();
      });
    }
  }

  Future<void> _captureAndPrintOrders(List<ItemVo> orderItems) async {
    try {

      List<Future<Uint8List?>> imageFutures = [];

      // Dynamically add screenshot captures based on the order items
      for (var item in orderItems) {
        switch (item.mainCategoryId) {
          case 3:
            imageFutures.add(screenshotControllerBar.capture(delay: const Duration(milliseconds: 50)));
            break;
          case 1:
            imageFutures.add(screenshotControllerKitchen.capture(delay: const Duration(milliseconds: 50)));
            break;
          case 2:
            imageFutures.add(screenshotControllerBBQ.capture(delay: const Duration(milliseconds: 50)));
            break;
          case 4:
            imageFutures.add(screenshotControllerCounter.capture(delay: const Duration(milliseconds: 50)));
            break;
          default:
          // Handle any other cases or show an error
            break;
        }
      }

      // Wait for all relevant captures to complete.
      List<Uint8List?> capturedImages = await Future.wait(imageFutures);

      // Now, dynamically assign captured images based on item types.
      for (int i = 0; i < orderItems.length; i++) {
        var item = orderItems[i];
        var image = capturedImages[i];

        if (image != null) {
          setState(() {
            switch (item.mainCategoryId) {
              case 3:
                theBarImage = image;
                break;
              case 1:
                theKitchenImage = image;
                break;
              case 2:
                theBBQImage = image;
                break;
              case 4:
                theCounterImage = image;
                break;
            }
          });
        } else {
          // Handle image capture failure
          showAlertDialogBox(context, 'Capture Image Error', 'Failed to capture image for ${item.mainCategoryId}');
        }
      }

      // After all relevant images are captured, print each type accordingly
      if (theBarImage != null) {
        await _printOrder(3, theBarImage!);
      }

      if (theKitchenImage != null) {
        await _printOrder(1, theKitchenImage!);
      }

      if (theBBQImage != null) {
        await _printOrder(2, theBBQImage!);
      }

      if (theCounterImage != null) {
        await _printOrder(4, theCounterImage!);
      }
    } catch (error) {
      showAlertDialogBox(context, 'Printing Error', error.toString());
    }
  }

  Future<void> _printOrder(int orderType, Uint8List image) async {
    // Based on the order type, call the correct printing method (Bluetooth/Network)
    PrinterConfig? config = _getPrinterConfigForOrderType(orderType);
    if (config != null) {
      if (config.type == 'Network') {
        await _printViaNetwork(config, image);
      } else if (config.type == 'Bluetooth') {
        await _printViaBluetooth(config, image);
      } else {
        showAlertDialogBox(context, 'Printing Error', 'Unsupported printer type for $orderType');
      }
    } else {
      showAlertDialogBox(context, 'Printing Error', 'No printer configuration found for $orderType');
    }
  }

  Future<void> _printViaBluetooth(PrinterConfig config,Uint8List screenshotImage) async {
    await _autoConnectSavedPrinter(config.address);
    var bloc = context.read<PrinterService>();
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes.addAll(_generateReceiptHeader(generator, config.name));

    try {
      final image = decodeImage(screenshotImage);
      if (image == null) {
        throw Exception("Failed to decode image.");
      }
      final resizedImage = copyResize(image,width: 576);  // 80mm printers
      bytes += generator.imageRaster(resizedImage);

      try {
        bool success = await PrintBluetoothThermal.writeBytes(bytes);
        if (success) {
          showSuccessScaffoldMessage(context, "Printing Success in ${config.name}");
        } else {
          showScaffoldMessage(context, "Printing failed in ${config.name}");
        }
      } catch (e, stackTrace) {
        showAlertDialogBox(context, 'Bluetooth Printing Error', e.toString());
        debugPrint("Error while printing: $e");
        debugPrint("StackTrace: $stackTrace");
      }

    } catch (e) {
      showAlertDialogBox(context, 'Bluetooth Printing failed', e.toString() );
    } finally {
      bloc.disconnectToDevice();
    }
  }

  Future<void> _printViaNetwork(PrinterConfig config,Uint8List screenshotImage) async{
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    bytes.addAll(_generateReceiptHeader(generator, config.name));

    final image = decodeImage(screenshotImage);
    if (image == null) {
      throw Exception("Failed to decode image.");
    }
    final resizedImage = copyResize(image,width: 576);  // 80mm printers
    bytes += generator.imageRaster(resizedImage);
    bytes += generator.cut();
    String printerIp = config.address;
    try {
      final socket = await Socket.connect(printerIp, 9100); // Port 9100 is commonly used for network printing
      socket.add(bytes);
      await socket.flush();
      await socket.close();
      showSuccessScaffoldMessage(context, '${config.name} printing success');
    } catch (e) {
      showAlertDialogBox(context, 'Printing failed in ',e.toString());
    }
  }

  PrinterConfig? _getPrinterConfigForOrderType(int orderType) {
    return printers.where((printer) => printer.id == orderType).first;
  }

  Future<void> _autoConnectSavedPrinter(String address) async {
    await _printerService?.connectToDevice(address, context);
  }

  List<int> _generateReceiptHeader(Generator generator, String printerName) {
    List<int> bytes = [];
    bytes.addAll(generator.text(
      'INNOCENT',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ));

    bytes.addAll(generator.text(
      '($printerName Orders)',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ));
    bytes.addAll(generator.text(formattedDateTime));
    bytes.addAll(generator.text('G-Floor, B4, 1'));
    bytes.addAll(generator.hr());

    // Table Header
    bytes.addAll(generator.row([
      PosColumn(text: 'Name', width: 4, styles: _defaultStyle(PosAlign.left)),
      PosColumn(text: 'Unit', width: 2, styles: _defaultStyle(PosAlign.center)),
      PosColumn(text: 'Qty', width: 2, styles: _defaultStyle(PosAlign.center)),
      PosColumn(text: 'Remark', width: 4, styles: _defaultStyle(PosAlign.right)),
    ]));

    return bytes;
  }

  @override
  void dispose() {
    if (_printerService != null && _printerService!.connected) {
      _printerService!.disconnectToDevice();
    }
    super.dispose();
  }

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetoothScan.isDenied ||
        await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
    }

    if (await Permission.bluetoothScan.isPermanentlyDenied ||
        await Permission.bluetoothConnect.isPermanentlyDenied) {
      openAppSettings(); // Opens the app settings to enable Nearby Devices
    }

    if (await Permission.bluetoothScan.isGranted && await Permission.bluetoothConnect.isGranted) {
      print("Bluetooth permissions granted");
    } else {
      print("Bluetooth permissions denied or Nearby Devices permission disabled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Page',style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.colorPrimary,
        leading: IconButton(
            onPressed: _onBackPressed,
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white)
        ),
        actions: [
          StreamBuilder<BluetoothAdapterState>(
            stream: FlutterBluePlus.adapterState,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data == BluetoothAdapterState.off) {
                  return const Icon(Icons.bluetooth, color: Colors.grey);
                } else {
                  return const Icon(Icons.bluetooth ,color: Colors.blue);
                }
              }
              else {
                return const CupertinoActivityIndicator();
              }
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Selector<PrinterService,bool>(
          //     selector: (context,bloc) => bloc.connected,
          //     builder: (context,connected,_){
          //       return Container(
          //         margin: const EdgeInsets.only(top: 16,bottom: 24),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             !connected
          //                 ? IconButton(
          //                   onPressed: () {
          //
          //                   },
          //                   icon: const Icon(
          //                     Icons.refresh,
          //                     color: CupertinoColors.black,
          //                     size: 18,
          //                   ),
          //                 )
          //                 : const SizedBox(width: 1),
          //
          //             const SizedBox(width: 4),
          //             Text(
          //               connected == true
          //                   ? 'Bluetooth Connected'
          //                   : 'Bluetooth is not connected',
          //               style: TextStyle(
          //                 color: context.watch<PrinterService>().connected == true
          //                     ? Colors.blue[800]
          //                     : Colors.black,
          //               ),
          //             )
          //           ],
          //         ),
          //       );
          //     }
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the Bar Order Screenshot Widget only if it's in the orderItems
              if (orderItems.any((item) => item.mainCategoryId == 3))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScreenshotReceiptWidget(
                      items: orderItems.where((item) => item.mainCategoryId == 3).toList(),
                      screenshotController: screenshotControllerBar, // Controller for Bar
                      listWidth: 200,
                      textSize: 14,
                      printerLocation: 'Bar',
                    ),
                    IconButton(onPressed: (){
                      if(theBarImage != null) {
                        return;
                      }
                      _printOrder(3, theBarImage!);
                    }, icon: const Icon(Icons.refresh,color: Colors.black,))
                  ],
                ),

              const SizedBox(height: 16),

              // Display the Kitchen Order Screenshot Widget only if it's in the orderItems
              if (orderItems.any((item) => item.mainCategoryId == 1))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScreenshotReceiptWidget(
                      items: orderItems.where((item) => item.mainCategoryId == 1).toList(),
                      screenshotController: screenshotControllerKitchen, // Controller for Kitchen
                      listWidth: 200,
                      textSize: 8,
                      printerLocation: 'Kitchen',
                    ),
                    IconButton(onPressed: (){
                      if(theKitchenImage == null) {
                        return;
                      }
                      _printOrder(1, theKitchenImage!);
                    }, icon: const Icon(Icons.refresh,color: Colors.black,))
                  ],
                ),

              const SizedBox(height: 16),

              // Optionally display other order types like BBQ, Counter based on the items
              if (orderItems.any((item) => item.mainCategoryId == 2))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScreenshotReceiptWidget(
                      items: orderItems.where((item) => item.mainCategoryId == 2).toList(),
                      screenshotController: screenshotControllerBBQ, // Controller for BBQ
                      listWidth: 200,
                      textSize: 8,
                      printerLocation: 'BBQ',
                    ),
                    IconButton(onPressed: (){
                      if(theBBQImage != null) {
                        return;
                      }
                      _printOrder(2, theBBQImage!);
                    }, icon: const Icon(Icons.refresh,color: Colors.black,))
                  ],
                ),

              const SizedBox(height: 16),

              if (orderItems.any((item) => item.mainCategoryId == 4))
                Row(
                  children: [
                    ScreenshotReceiptWidget(
                      items: orderItems.where((item) => item.mainCategoryId == 4).toList(),
                      screenshotController: screenshotControllerCounter, // Controller for Counter
                      listWidth: 200,
                      textSize: 8,
                      printerLocation: 'Counter',
                    ),

                  ],
                ),

              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                  child: ElevatedButton.icon(
                      onPressed: () async{
                        _captureAndPrintOrders(orderItems);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      icon: const Icon(
                        Icons.print,
                        color: Colors.white70,
                      ),
                      label: const Text('Print',style: TextStyle(color: Colors.white),)),
                ),
            ],
          ),
        ],
      )
    );
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  PosStyles _defaultStyle(PosAlign align) {
    return PosStyles(
      align: align,
      fontType: PosFontType.fontA,
      height: PosTextSize.size1,
      width: PosTextSize.size1,
    );
  }
}
