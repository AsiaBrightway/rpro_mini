import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/bluetooth_service.dart';
import '../themes/colors.dart';

class PrinterConfigPage extends StatefulWidget {
  const PrinterConfigPage({super.key});

  @override
  _PrinterConfigPageState createState() => _PrinterConfigPageState();
}

class _PrinterConfigPageState extends State<PrinterConfigPage> {
  PrinterService? _printerService;
  final TextEditingController _fontSizeController = TextEditingController();
  String? _selectedPrinterMac;

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    _loadConfig();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printerService = context.read<PrinterService>();
      _printerService?.getPairedDevices();
    });
  }

  Future<void> _loadConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSizeController.text = prefs.getString('fontSize') ?? '12';
      _selectedPrinterMac = prefs.getString('printerMac');
    });
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
  void dispose() {
    if (_printerService != null && _printerService!.connected) {
      _printerService!.disconnectToDevice();
    }
    super.dispose();
  }


  Future<void> _saveConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontSize', _fontSizeController.text);
    if (_selectedPrinterMac != null) {
      await prefs.setString('printerMac', _selectedPrinterMac!);
    }
    showSuccessToast(context, 'Saved successfully');
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<PrinterService>();
    return Scaffold(
      appBar: AppBar(title: Text('Printer Configuration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                            setState(() {
                              _selectedPrinterMac = device.macAdress;
                            });
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
            TextField(
              controller: _fontSizeController,
              decoration: InputDecoration(
                labelText: 'Font Size',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            // You can build a drop-down or a list view to select a printer.
            ElevatedButton(
              onPressed: () async {
                // Example: simulate selecting a printer MAC address
                await _saveConfig();
              },
              child: Text('Select Printer & Save'),
            ),
          ],
        ),
      ),
    );
  }
}
