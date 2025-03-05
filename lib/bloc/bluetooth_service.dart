// printer_service.dart

import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:rpro_mini/utils/helper_functions.dart';

class PrinterService extends ChangeNotifier {
  List<BluetoothInfo> pairedDevices = [];
  String tips = '';
  bool disconnected = false;
  bool connected = false;
  String? _selectedDeviceMac;
  bool? _isBluetoothEnabled;

  bool? get isBluetoothEnabled => _isBluetoothEnabled;
  String? get selectedDeviceMac => _selectedDeviceMac;

  Future<void> getPairedDevices() async {
    try {
      _isBluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      pairedDevices = await PrintBluetoothThermal.pairedBluetooths;
      notifyListeners();
    } catch (e) {
      print("Error fetching paired devices: $e");
    }
  }

  Future<void> disconnectToDevice() async{
    disconnected = await PrintBluetoothThermal.disconnect;
    connected = false;
    notifyListeners();
  }

  Future<void> connectToDevice(String macAddress,BuildContext context) async {
    await PrintBluetoothThermal.disconnect;
    try {
      connected = await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      if(!connected){
        showScaffoldMessage(context, 'Failed to connect');
      }
      else{
        _selectedDeviceMac = macAddress;
      }
      notifyListeners();
    } catch (e) {
      print("Connection error: $e");
    }
  }
}
