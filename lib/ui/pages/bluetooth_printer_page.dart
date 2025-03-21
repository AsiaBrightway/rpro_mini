
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/ui/components/screenshot_widget.dart';
import 'package:screenshot/screenshot.dart';
import '../../bloc/bluetooth_service.dart';
import 'package:image/image.dart';
import '../components/ImagestorByte.dart';

class BluetoothPrinterPage extends StatefulWidget {
  const BluetoothPrinterPage({super.key});

  @override
  _BluetoothPrinterPageState createState() => _BluetoothPrinterPageState();
}

class _BluetoothPrinterPageState extends State<BluetoothPrinterPage> {
  ScreenshotController screenshotController = ScreenshotController();
  List<BluetoothInfo> pairedDevices = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _printSampleReceipt() async {
    var bloc = context.read<PrinterService>();
      // final profile = await CapabilityProfile.load();
      // final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];
      final image = decodeImage(theimageThatComesfromThePrinter);
      // bytes += generator.imageRaster(image!);
      await PrintBluetoothThermal.writeBytes(bytes);
      if(!mounted){
        bloc.disconnectToDevice();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Center(
            //   child: ScreenshotReceiptWidget(screenshotController: screenshotController, listWidth: 260,textSize: 14),
            // ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: (){
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
              label: const Text("Print Receipt",style: TextStyle(color: Colors.black),),
            ),
              // ElevatedButton(
              //   onPressed: disconnectToDevice,
              //   child: const Text("Disconnect printer"),
              // ),
        ],
        ),
      ),
    );
  }
}
