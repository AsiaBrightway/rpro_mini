import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/bluetooth_service.dart';
import '../../data/vos/printer_config.dart';

class PrinterConfigPage extends StatefulWidget {
  const PrinterConfigPage({super.key});

  @override
  _PrinterConfigPageState createState() => _PrinterConfigPageState();
}

class _PrinterConfigPageState extends State<PrinterConfigPage> {
  PrinterService? _printerService;
  List<PrinterConfig> printers = [
    PrinterConfig(id: 1,name: 'Kitchen', type: 'Network', address: '', textSize: 8, width: 200),
    PrinterConfig(id: 2, name: 'BBQ', type: 'Network', address: '', textSize: 8, width: 200),
    PrinterConfig(id: 3, name: 'Bar', type: 'Network', address: '', textSize: 8, width: 200),
    PrinterConfig(id: 4, name: 'Counter', type: 'Network', address: '', textSize: 8, width: 200),
  ];

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

  Future<void> _savePrinterConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> printerList = printers.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('printer_config', printerList);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Printer configurations saved!")),
    );
  }

  // Load saved printer config
  Future<void> _loadPrinterConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? printerList = prefs.getStringList('printer_config');

    if (printerList != null) {
      setState(() {
        printers = printerList.map((p) => PrinterConfig.fromJson(jsonDecode(p))).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Printer Configuration')),
      body: ListView.builder(
        itemCount: printers.length,
        itemBuilder: (context, index) {
          return _buildPrinterTile(printers[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _savePrinterConfig,
        child: const Icon(Icons.save,color: Colors.black),
      ),
    );
  }

  Widget _buildPrinterTile(PrinterConfig printer, int index) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: Selector<PrinterService, List<BluetoothInfo>>(
                selector: (context, bloc) => bloc.pairedDevices,
                builder: (context, pairedDevices, _) {
                  return ListView.builder(
                    itemCount: pairedDevices.length,
                    itemBuilder: (context, index) {
                      var bloc = context.read<PrinterService>();
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
                              //todo
                              device.macAdress;
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Text(printer.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Printer Type (Network / Bluetooth)
            DropdownButton<String>(
              value: printer.type,
              focusColor: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(12),
              onChanged: (value) {
                setState(() {
                  printers[index].type = value!;
                });
              },
              items: ['Network', 'Bluetooth']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
            ),
            // Printer Address Input
            TextField(
              decoration: const InputDecoration(labelText: 'Address (IP or MAC)',labelStyle: TextStyle(color: Colors.grey)),
              onChanged: (value) {
                printers[index].address = value;
              },
              controller: TextEditingController(text: printer.address),
            ),
            const SizedBox(height: 8),
            // Text Size Input
            TextField(
              decoration: const InputDecoration(labelText: 'Text Size',labelStyle: TextStyle(color: Colors.grey)),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                printers[index].textSize = int.tryParse(value) ?? 12;
              },
              controller: TextEditingController(text: printer.textSize.toString()),
            ),
            const SizedBox(height: 8),
            // Width Input
            TextField(
              decoration: InputDecoration(labelText: 'Width',labelStyle: TextStyle(color: Colors.grey)),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                printers[index].width = int.tryParse(value) ?? 80;
              },
              controller: TextEditingController(text: printer.width.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
