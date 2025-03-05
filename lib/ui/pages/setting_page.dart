
import 'dart:async';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/ui/components/screenshot_widget.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:screenshot/screenshot.dart';
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
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  PrinterService? _printerService;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        if(_adapterState == BluetoothAdapterState.off){
          showAlertDialogBox(context, 'Bluetooth','Please enable bluetooth and refresh');
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printerService = context.read<PrinterService>();
      _printerService?.getPairedDevices();
    });
  }

  Future<void> _printSampleReceipt() async {
    var bloc = context.read<PrinterService>();
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    final image = decodeImage(theimageThatComesfromThePrinter);
    bytes += generator.imageRaster(image!);
    await PrintBluetoothThermal.writeBytes(bytes);
    if(!mounted){
      bloc.disconnectToDevice();
    }
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
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

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<PrinterService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Page',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: AppColors.colorPrimary,
        leading: IconButton(
            onPressed: _onBackPressed,
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white)
        ),
      ),
      body: Column(
        children: [
          Selector<PrinterService,bool?>(
            selector: (context,bloc) => bloc.isBluetoothEnabled,
            builder: (context,isEnabled,_) {
              if(isEnabled == null){
                return const CircularProgressIndicator();
              }
              else if (!isEnabled){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Enable Bluetooth in your settings'),
                    TextButton(
                        onPressed: () => bloc.getPairedDevices(),
                        child: const Icon(Icons.refresh)),
                  ],
                );
              }
              else{
                return const SizedBox(height: 1);
              }
            }
            ),
          Expanded(
            child: Selector<PrinterService, List<BluetoothInfo>>(
              selector: (context, bloc) => bloc.pairedDevices,
              builder: (context, pairedDevices, _) {
                return ListView.builder(
                  itemCount: pairedDevices.length,
                  itemBuilder: (context, index) {
                    final device = pairedDevices[index];
                    return Card(
                      child: ListTile(
                        title: Text(device.name,style: TextStyle(color: AppColors.colorPrimary)),
                        subtitle: Text(device.macAdress,style: const TextStyle(color: Colors.black)),
                        trailing: Selector<PrinterService, bool>(
                          selector: (context, bloc) => bloc.connected,
                          builder: (context, isConnected, _) {
                            if (bloc.selectedDeviceMac == device.macAdress && isConnected) {
                              return const Icon(Icons.check_circle, color: Colors.green);
                            } else {
                              return const SizedBox(width: 1);
                            }
                          },
                        ),
                        onTap: () {
                          // Check if the device is already connected
                          if (bloc.selectedDeviceMac == device.macAdress && bloc.connected) {
                            // Disconnect the device if it’s already connected
                            bloc.disconnectToDevice();
                          } else {
                            // Connect to the device if it’s not connected
                            bloc.connectToDevice(device.macAdress, context);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ScreenshotReceiptWidget(screenshotController: screenshotController),
          const SizedBox(height: 16,),
          ElevatedButton.icon(onPressed: (){
                screenshotController
                    .capture(delay: const Duration(milliseconds: 10))
                    .then((capturedImage) async {
                  theimageThatComesfromThePrinter = capturedImage!;
                  setState(() {
                    theimageThatComesfromThePrinter = capturedImage;
                    _printSampleReceipt();

                  });
                }).catchError((onError) {
                  print(onError);
                });
              },
              icon: Icon(Icons.print,color: Colors.greenAccent.shade700,),
              label: const Text('Print')),
          const SizedBox(height: 16)
        ],
      )
    );
  }
}
