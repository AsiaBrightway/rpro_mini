import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
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
    showSuccessScaffoldMessage(context, 'Printer configuration saved');
  }

  void _onBackPressed(){
    Navigator.of(context).pop();
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
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
          backgroundColor: AppColors.colorPrimary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: _onBackPressed,
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          ),
          actions: [
            Selector<PrinterService, List<BluetoothInfo>>(
              selector: (context, bloc) => bloc.pairedDevices,
              builder: (context, pairedDevices, _) {
                if(pairedDevices.isNotEmpty){
                  return TextButton(
                      onPressed: (){
                        _showPairedDevicesBottomSheet(context, context.read<PrinterService>());
                      },
                      child: const Text('Printers',style: TextStyle(color: Colors.white),));
                }else{
                  return TextButton(
                      onPressed: (){},
                      child: const Text('Not found',style: TextStyle(color: Colors.white)));
                }
              },
            )
          ],
          title: const Text('Printer Configuration',style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu',fontSize: 16))
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: printers.length,
              itemBuilder: (context, index) {
                return _buildPrinterTile(printers[index], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.colorNavBackground,
        onPressed: _savePrinterConfig,
        child: Icon(Icons.save,color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget _buildPrinterTile(PrinterConfig printer, int index) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(printer.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Printer Type (Network / Bluetooth)
            DropdownButton<String>(
              value: printer.type,
              focusColor: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(8),
              dropdownColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
              decoration: const InputDecoration(labelText: 'Width',labelStyle: TextStyle(color: Colors.grey)),
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

  void _showPairedDevicesBottomSheet(BuildContext context, PrinterService printerService) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select a Printer", style: TextStyle(color: Colors.black87,fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: printerService.pairedDevices.length,
                  padding: const EdgeInsets.only(bottom: 48),
                  itemBuilder: (context, index) {
                    final device = printerService.pairedDevices[index];
                    return Card(
                      child: ListTile(
                        title: Text(device.name, style: TextStyle(color: AppColors.colorPrimary)),
                        subtitle: Text(device.macAdress, style: const TextStyle(color: Colors.black)),
                        onTap: () {
                          // Copy to clipboard
                          Clipboard.setData(ClipboardData(text: device.macAdress));

                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
