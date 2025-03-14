
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:image/image.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
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
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printerService = context.read<PrinterService>();
      _printerService?.getPairedDevices();
    });
    // _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
    //   _adapterState = state;
    //   if (mounted) {
    //     if(_adapterState == BluetoothAdapterState.off){
    //       showAlertDialogBox(context, 'Bluetooth','Please enable bluetooth and refresh');
    //     }
    //   }
    // });

    _autoConnectSavedPrinter();
  }

  Future<void> _autoConnectSavedPrinter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPrinterMac = prefs.getString('printerMac');
    if (savedPrinterMac != null) {
      if(!mounted) return;
      await _printerService?.connectToDevice(savedPrinterMac, context);
    }
  }

  Future<void> _printViaBluetooth() async {
    var bloc = context.read<PrinterService>();
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];


    // bytes.addAll(generator.text(
    //   'INNOCENT',
    //   styles: const PosStyles(
    //     align: PosAlign.center,
    //     bold: true,
    //     height: PosTextSize.size1,
    //     width: PosTextSize.size1,
    //   ),
    // ));
    //
    // bytes.addAll(generator.text(
    //   '(Bar and Refrigerator Orders)',
    //   styles: const PosStyles(
    //     align: PosAlign.center,
    //     bold: true,
    //     height: PosTextSize.size1,
    //     width: PosTextSize.size1,
    //   ),
    // ));

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

    final image = decodeImage(theimageThatComesfromThePrinter);
    bytes += generator.imageRaster(image!);
    await PrintBluetoothThermal.writeBytes(bytes);
    if(!mounted){
      bloc.disconnectToDevice();
    }
  }

  Future<void> _printViaNetwork() async{
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

    final String myanmarText = 'မင်္ဂလာပါ'; // Myanmar text
    final Uint8List customBytes = convertMyanmarTextToCustomBytes(myanmarText);
    bytes += generator.textEncoded(customBytes); // Send custom bytes

    final Uint8List custom = Uint8List.fromList([
      0x1000// Line feed
    ]);

    bytes += generator.textEncoded(custom); // Send custom bytes
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
        text: 'Arkar',
        width: 4,
        styles: const PosStyles(
          align: PosAlign.right,
          fontType: PosFontType.fontA,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
    ]));

    bytes.addAll(generator.row([
      PosColumn(
        textEncoded: await getEncoded('ကခ'),
        width: 12,
        styles: const PosStyles(align: PosAlign.center),
      )
    ]));

    // final image = decodeImage(theimageThatComesfromThePrinter);
    // bytes += generator.imageRaster(image!);
    bytes+= generator.cut();
    const printerIp = '192.168.1.87';
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
    final encoded = await CharsetConverter.encode("UTF8", text);
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
                  _autoConnectSavedPrinter();
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
                              _autoConnectSavedPrinter();
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
              ScreenshotReceiptWidget(screenshotController: screenshotController),
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
                          //_printSampleReceipt();
                          _printViaNetwork();
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
                const SizedBox(height: 16)
            ],
          ),
        ],
      )
    );
  }

  Uint8List convertMyanmarTextToCustomBytes(String text) {
    // Custom code table for Myanmar characters
    final Map<String, int> myanmarCodeTable = {
      'က': 0x1000,
      'ခ': 0x1001,
      'ဂ': 0x1002,
      'ဃ': 0x1003,
      'င': 0x1004,
      'စ': 0x1005,
      'ဆ': 0x1006,
      'ဇ': 0x1007,
      'ဈ': 0x1008,
      'ဉ': 0x1009,
      'ည': 0x100A,
      'ဋ': 0x100B,
      'ဌ': 0x100C,
      'ဍ': 0x100D,
      'ဎ': 0x100E,
      'ဏ': 0x100F,
      'တ': 0x1010,
      'ထ': 0x1011,
      'ဒ': 0x1012,
      'ဓ': 0x1013,
      'န': 0x1014,
      'ပ': 0x1015,
      'ဖ': 0x1016,
      'ဗ': 0x1017,
      'ဘ': 0x1018,
      'မ': 0x1019,
      'ယ': 0x101A,
      'ရ': 0x101B,
      'လ': 0x101C,
      'ဝ': 0x101D,
      'သ': 0x101E,
      'ဟ': 0x101F,
      'ဠ': 0x1020,
      'အ': 0x1021,
      'ဢ': 0x1022,
      'ဣ': 0x1023,
      'ဤ': 0x1024,
      'ဥ': 0x1025,
      'ဦ': 0x1026,
      'ဧ': 0x1027,
      'ဨ': 0x1028,
      'ဩ': 0x1029,
      'ဪ': 0x102A,
      'ါ': 0x102B,
      'ာ': 0x102C,
      'ိ': 0x102D,
      'ီ': 0x102E,
      'ု': 0x102F,
      'ူ': 0x1030,
      'ေ': 0x1031,
      'ဲ': 0x1032,
      'ဳ': 0x1033,
      'ဴ': 0x1034,
      'ဵ': 0x1035,
      'ံ': 0x1036,
      '့': 0x1037,
      'း': 0x1038,
      '္': 0x1039,
      '်': 0x103A,
      'ျ': 0x103B,
      'ြ': 0x103C,
      'ွ': 0x103D,
      'ှ': 0x103E,
      'ဿ': 0x103F,
      '၀': 0x1040,
      '၁': 0x1041,
      '၂': 0x1042,
      '၃': 0x1043,
      '၄': 0x1044,
      '၅': 0x1045,
      '၆': 0x1046,
      '၇': 0x1047,
      '၈': 0x1048,
      '၉': 0x1049,
      '၊': 0x104A,
      '။': 0x104B,
      '၌': 0x104C,
      '၍': 0x104D,
      '၎': 0x104E,
      '၏': 0x104F,
      'ၐ': 0x1050,
      'ၑ': 0x1051,
      'ၒ': 0x1052,
      'ၓ': 0x1053,
      'ၔ': 0x1054,
      'ၕ': 0x1055,
      'ၖ': 0x1056,
      'ၗ': 0x1057,
      'ၘ': 0x1058,
      'ၙ': 0x1059,
      'ၚ': 0x105A,
      'ၛ': 0x105B,
      'ၜ': 0x105C,
      'ၝ': 0x105D,
      'ၞ': 0x105E,
      'ၟ': 0x105F,
      'ၠ': 0x1060,
      'ၡ': 0x1061,
      'ၢ': 0x1062,
      'ၣ': 0x1063,
      'ၤ': 0x1064,
      'ၥ': 0x1065,
      'ၦ': 0x1066,
      'ၧ': 0x1067,
      'ၨ': 0x1068,
      'ၩ': 0x1069,
      'ၪ': 0x106A,
      'ၫ': 0x106B,
      'ၬ': 0x106C,
      'ၭ': 0x106D,
      'ၮ': 0x106E,
      'ၯ': 0x106F,
      'ၰ': 0x1070,
      'ၱ': 0x1071,
      'ၲ': 0x1072,
      'ၳ': 0x1073,
      'ၴ': 0x1074,
      'ၵ': 0x1075,
      'ၶ': 0x1076,
      'ၷ': 0x1077,
      'ၸ': 0x1078,
      'ၹ': 0x1079,
      'ၺ': 0x107A,
      'ၻ': 0x107B,
      'ၼ': 0x107C,
      'ၽ': 0x107D,
      'ၾ': 0x107E,
      'ၿ': 0x107F,
      'ႀ': 0x1080,
      'ႁ': 0x1081,
      'ႂ': 0x1082,
      'ႃ': 0x1083,
      'ႄ': 0x1084,
      'ႅ': 0x1085,
      'ႆ': 0x1086,
      'ႇ': 0x1087,
      'ႈ': 0x1088,
      'ႉ': 0x1089,
      'ႊ': 0x108A,
      'ႋ': 0x108B,
      'ႌ': 0x108C,
      'ႍ': 0x108D,
      'ႎ': 0x108E,
      'ႏ': 0x108F,
      '႐': 0x1090,
      '႑': 0x1091,
      '႒': 0x1092,
      '႓': 0x1093,
      '႔': 0x1094,
      '႕': 0x1095,
      '႖': 0x1096,
      '႗': 0x1097,
      '႘': 0x1098,
      '႙': 0x1099,
      'ႚ': 0x109A,
      'ႛ': 0x109B,
      'ႜ': 0x109C,
      'ႝ': 0x109D,
      '႞': 0x109E,
      '႟': 0x109F,
    };

    final List<int> bytes = [];
    for (int i = 0; i < text.length; i++) {
      final String char = text[i];
      if (myanmarCodeTable.containsKey(char)) {
        bytes.add(myanmarCodeTable[char]!);
      } else {
        bytes.add(0x20); // Fallback to space for unsupported characters
      }
    }
    return Uint8List.fromList(bytes);
  }
}
