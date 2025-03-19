
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/vos/printer_config.dart';
import 'package:rpro_mini/ui/components/screenshot_widget.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/bluetooth_service.dart';
import '../../utils/helper_functions.dart';
import '../components/ImagestorByte.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ScreenshotController screenshotController = ScreenshotController();
  //BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  PrinterService? _printerService;
  List<PrinterConfig> printers = [];
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
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

  List<int> getOrderTypes() {
    return [1, 2];
  }

  Future<void> _printOrder() async {
    // First, load the printer configurations.
    await _loadPrinterConfig();

    // Determine which types of orders are present.
    List<int> orderTypes = getOrderTypes();

    for (var orderType in orderTypes) {
      // Find a printer configuration that matches the order type.
      PrinterConfig? config = printers.where((printer) => printer.id == orderType).first;
        // Call the appropriate printing method based on the connection type.
        if (config.type == 'Network') {
          await _printViaNetwork(config);
        } else if (config.type == 'Bluetooth') {
          await _printViaBluetooth(config);
        } else {
          // Handle other connection types or show an error.
          showAlertDialogBox(context, 'Printing Error', 'Unsupported connection type');
        }

    }
  }

  Future<void> _autoConnectSavedPrinter(String address) async {
      await _printerService?.connectToDevice(address, context);
  }

  Future<void> _printViaBluetooth(PrinterConfig config) async {
    await _autoConnectSavedPrinter(config.address);
    var bloc = context.read<PrinterService>();
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
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
      '(Bar and Refrigerator Orders)',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ));

    bytes.addAll(generator.text('2025-02-20, 2:49 PM (700)'));
    bytes.addAll(generator.text('G-Floor, B4, 1'));
    bytes.addAll(generator.hr());

    //Table Header
    bytes.addAll(generator.row([
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
    ]));

    try {
      final image = decodeImage(theimageThatComesfromThePrinter);
      if (image == null) {
        throw Exception("Failed to decode image.");
      }
      bytes += generator.imageRaster(image);

      bool success = await PrintBluetoothThermal.writeBytes(bytes);
      if(success){
        showSuccessScaffoldMessage(context, "Printing Success in ${config.name}");
      }else{
        showScaffoldMessage(context, "Printing failed in ${config.name}");
      }

    } catch (e) {
      showScaffoldMessage(context, "Printing failed: ${e.toString()}");
    } finally {
      // Ensure the device disconnects when done
      if (!mounted) {
        bloc.disconnectToDevice();
      }
    }
  }

  Future<void> _printViaNetwork(PrinterConfig config) async{
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
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
      '(Bar and Refrigerator Orders)',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ));

    bytes.addAll(generator.text('2025-02-20, 2:49 PM (700)'));
    bytes.addAll(generator.text('G-Floor, B4, 1'));
    bytes.addAll(generator.hr());
    /// Table Header
    bytes.addAll(generator.row([
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
    ]));

    final image = decodeImage(theimageThatComesfromThePrinter);
    bytes += generator.imageRaster(image!);
    bytes+= generator.cut();
    String printerIp = config.address;
    try {
      final socket = await Socket.connect(printerIp, 9100); // Port 9100 is commonly used for network printing
      socket.add(bytes);
      await socket.flush();
      await socket.close();
      showSuccessScaffoldMessage(context, '${config.name} printing success');
    } catch (e) {
      showScaffoldMessage(context, 'Printing failed in ${config.name}');
    }
  }

  @override
  void dispose() {
    //_adapterStateStateSubscription.cancel();
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

  Future<Uint8List> getEncoded(String text) async {
    final encoded = await CharsetConverter.encode("UTF16", text);
    return encoded;
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
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
          Selector<PrinterService,bool>(
              selector: (context,bloc) => bloc.connected,
              builder: (context,connected,_){
                return Container(
                  margin: const EdgeInsets.only(top: 16,bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !connected
                          ? IconButton(
                            onPressed: () {

                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: CupertinoColors.black,
                              size: 18,
                            ),
                          )
                          : const SizedBox(width: 1),

                      const SizedBox(width: 4),
                      Text(
                        connected == true
                            ? 'Bluetooth Connected'
                            : 'Bluetooth is not connected',
                        style: TextStyle(
                          color: context.watch<PrinterService>().connected == true
                              ? Colors.blue[800]
                              : Colors.black,
                        ),
                      )
                    ],
                  ),
                );
              }
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScreenshotReceiptWidget(screenshotController: screenshotController, listWidth: 200, textSize: 8),

              const SizedBox(height: 16,),
              SizedBox(
                width: 200,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        screenshotController
                            .capture(delay: const Duration(milliseconds: 10))
                            .then((capturedImage) async {
                              theimageThatComesfromThePrinter = capturedImage!;
                              setState(() {
                                theimageThatComesfromThePrinter = capturedImage;
                              });
                              _printOrder();
                            }).catchError((onError) {
                              showAlertDialogBox(
                                  context, 'Printing Error: ', onError.toString());
                            });
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
}
