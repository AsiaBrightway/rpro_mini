
import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
import 'package:rpro_mini/bloc/print_receipt_bloc.dart';
import 'package:rpro_mini/data/vos/printer_config.dart';
import 'package:rpro_mini/network/api_constants.dart';
import 'package:rpro_mini/ui/components/screenshot_widget.dart';
import 'package:rpro_mini/ui/pages/home_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/auth_provider.dart';
import '../../bloc/bluetooth_service.dart';
import '../../data/vos/order_details_vo.dart';
import '../../utils/helper_functions.dart';

class SettingPage extends StatefulWidget {
  final bool isCancel;
  final List<OrderDetailsVo> orderItems;
  final int tableId;
  final String tableName;
  final String floorName;
  final int groupName;
  const SettingPage({super.key, required this.orderItems, required this.tableName, required this.floorName, required this.groupName, required this.isCancel, required this.tableId});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  String formattedDateTime = DateFormat('yyyy-MM-dd h:mm:ss a').format(DateTime.now());
  ScreenshotController screenshotControllerBar = ScreenshotController();
  ScreenshotController screenshotControllerKitchen = ScreenshotController();
  ScreenshotController screenshotControllerBBQ = ScreenshotController();
  ScreenshotController screenshotControllerCounter = ScreenshotController();
  bool _permissionsRequested = false;

  Uint8List? theBarImage; //3
  Uint8List? theKitchenImage; //1
  Uint8List? theBBQImage; //2
  Uint8List? theCounterImage; //4

  String restaurantName = '';
  String empName = '';
  int userId = 0;
  PrinterService? _printerService;
  List<PrinterConfig> printers = [];

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    _loadPrinterConfig();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printerService = context.read<PrinterService>();
    });

    final authModel = Provider.of<AuthProvider>(context,listen: false);
    empName = authModel.empName;
    userId = authModel.userId;
    restaurantName = authModel.restName;
  }

  Future<void> _loadPrinterConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? printerList = prefs.getStringList('printer_config');
    if (printerList != null) {
      setState(() {
        printers = printerList.map((p) => PrinterConfig.fromJson(jsonDecode(p))).toList();
      });
    }
    else {
      if(!mounted) return;
      showScaffoldMessage(context, 'Printer config is empty');
    }
  }

  List<OrderDetailsVo> removeDuplicates(List<OrderDetailsVo> orderItems) {
    final Set<int> seenCategories = {};
    final List<OrderDetailsVo> uniqueItems = [];

    for (final item in orderItems) {
      if (!seenCategories.contains(item.mainCategoryId)) {
        seenCategories.add(item.mainCategoryId);
        uniqueItems.add(item);
      }
    }

    return uniqueItems;
  }

  Future<void> _captureAndPrintOrders(List<OrderDetailsVo> orderItems,PrintReceiptBloc bloc) async {
    try {
      //List<Future<Uint8List?>> imageFutures = [];
      final List<OrderDetailsVo> filteredItems = removeDuplicates(orderItems);

      final Map<int, ScreenshotController> categoryToController = {
        1: screenshotControllerKitchen,
        2: screenshotControllerBBQ,
        3: screenshotControllerBar,
        4: screenshotControllerCounter,
      };

      // 2. Filter items to ONLY those with valid controllers
      final validItems = filteredItems.where((item) =>
          categoryToController.containsKey(item.mainCategoryId)
      ).toList();

      // 3. Capture images ONLY for valid items
      final imageFutures = validItems.map((item) =>
          categoryToController[item.mainCategoryId]!.capture(delay: Duration(milliseconds: 150))
      ).toList();

      // 4. Now guaranteed: validItems.length == capturedImages.length
      List<Uint8List?> capturedImages = await Future.wait(imageFutures);

      // 5. Safe assignment - indices always match
      for (int i = 0; i < validItems.length; i++) {
        final item = validItems[i];
        final image = capturedImages[i]; // CANNOT crash here

        if (image != null) {
          switch (item.mainCategoryId) {
            case 1: theKitchenImage = image; break;
            case 2: theBBQImage = image; break;
            case 3: theBarImage = image; break;
            case 4: theCounterImage = image; break;
          }
        }
      }
      bloc.isClickedPrintAll = true;
      // After all relevant images are captured, print each type accordingly
      if (theBarImage != null) {
        await _printOrder(3, theBarImage!,bloc);
      }

      if (theKitchenImage != null) {
        await _printOrder(1, theKitchenImage!,bloc);
      }

      if (theBBQImage != null) {
        await _printOrder(2, theBBQImage!,bloc);
      }

      if (theCounterImage != null) {
        await _printOrder(4, theCounterImage!,bloc);
      }
    } catch (error) {
      _showAlertDialogMessage('Printing Error Capture', error.toString());
      bloc.isClickedPrintAll = false;
    }
  }

  Future<void> _printOrder(int orderType, Uint8List image, PrintReceiptBloc bloc) async {
    // Retrieve the printer configuration for the given order type.
    PrinterConfig? config = _getPrinterConfigForOrderType(orderType);
    if (config != null) {
      if (config.type == 'Network') {
        await _printViaNetwork(config, image, bloc);
      } else if (config.type == 'Bluetooth') {
        await _printViaBluetooth(config, image, bloc);
      } else {
        showScaffoldMessage(context,'Unsupported printer type for $orderType');
      }
    } else {
      showAlertDialogBox(
          context, 'Printing Error', 'No printer configuration found for $orderType');
    }
  }

  Future<void> _printViaBluetooth(PrinterConfig config, Uint8List screenshotImage, PrintReceiptBloc bloc) async {
    bloc.changePrintState(config.name, 1); // show loading state
    var printerBloc = context.read<PrinterService>();
    try {
      // Auto connect to the printer
      await _autoConnectSavedPrinter(config.address);

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];

      // Generate header commands for receipt
      bytes.addAll(_generateReceiptHeader(generator, config.name));

      // Decode and process the image.
      final image = decodeImage(screenshotImage);
      if (image == null) {
        throw Exception("Failed to decode image.");
      }
      final resizedImage = copyResize(image, width: 576); // For 80mm printers.
      bytes.addAll(generator.imageRaster(resizedImage));
      bytes.addAll(generator.hr(ch: '- -'));

      // Write bytes to the printer.
      bool success = await PrintBluetoothThermal.writeBytes(bytes);
      if (success) {
        bloc.changePrintState(config.name, 2);
        _showSuccessMessage('Printing success in ${config.name}');

      } else {
        bloc.changePrintState(config.name, 3);
        if(!mounted) return;
        showAlertDialogBox(context, 'Printing Failed Bluetooth',
            'Unknown error in printer ${config.name}');
      }
    } catch (e) {
      bloc.changePrintState(config.name, 3);
      showAlertDialogBox(context, 'Bluetooth Printing Failed', e.toString());
    } finally {
      // Ensuring proper disconnection
      await Future.delayed(const Duration(milliseconds: 200));
      printerBloc.disconnectToDevice();
    }
  }

  Future<void> _printViaNetwork(PrinterConfig config, Uint8List screenshotImage, PrintReceiptBloc bloc) async {
    bloc.changePrintState(config.name, 1); // show loading state
    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];
      bytes.addAll(_generateReceiptHeader(generator, config.name));

      // Decode and process the image.
      final image = decodeImage(screenshotImage);
      if (image == null) {
        throw Exception("Failed to decode image.");
      }
      final resizedImage = copyResize(image, width: 576); // For 80mm printers.
      bytes.addAll(generator.imageRaster(resizedImage));
      await Future.delayed(const Duration(milliseconds: 800));
      bytes.addAll(generator.cut());

      String printerIp = config.address;
      // Connect to the network printer.
      final socket = await Socket.connect(printerIp, 9100);
      socket.add(bytes);
      await socket.flush();
      await socket.close();
      bloc.changePrintState(config.name, 2);
      _showSuccessMessage('${config.name} printing success');
    } catch (e) {
      bloc.changePrintState(config.name, 3);
      _showAlertDialogMessage('Printing Failed Network', e.toString());
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
    if (widget.isCancel) {
      bytes.addAll(generator.text(
        "Cancel Order",
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ));
    } else {
      bytes.addAll(generator.text(
        restaurantName,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ));
    }
    bytes.addAll(generator.feed(1));
    if (!widget.isCancel) {
      bytes.addAll(generator.text(
        '($printerName Orders)',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ));
    }
    bytes.addAll(generator.text(formattedDateTime));
    bytes.addAll(generator.text('${widget.floorName}, ${widget.tableName}, ${widget.groupName}'));
    bytes.addAll(generator.text(empName));
    bytes.addAll(generator.feed(1));
    if (!widget.isCancel) {
      bytes.addAll(generator.row([
        PosColumn(text: 'Name', width: 4, styles: _defaultStyle(PosAlign.left)),
        PosColumn(text: 'Unit', width: 2, styles: _defaultStyle(PosAlign.center)),
        PosColumn(text: 'Qty', width: 2, styles: _defaultStyle(PosAlign.center)),
        PosColumn(text: 'Remark', width: 4, styles: _defaultStyle(PosAlign.right)),
      ]));
    }
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
    if (_permissionsRequested) return;
    _permissionsRequested = true;

    if (await Permission.bluetoothScan.isDenied ||
        await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }

    if (await Permission.bluetoothScan.isPermanentlyDenied ||
        await Permission.bluetoothConnect.isPermanentlyDenied) {
      openAppSettings();
    }

    if (await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted) {
      //granted
    } else {
      //denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PrintReceiptBloc(widget.tableId,widget.groupName,widget.orderItems,userId),
      builder: (context,child){
        var bloc = context.read<PrintReceiptBloc>();
        return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            appBar: AppBar(
              title: Text(
                  widget.isCancel ? 'Order Cancel': 'New Order',
                  style: const TextStyle(color: Colors.white)),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Selector<PrintReceiptBloc,OrderState>(
                            selector: (context,bloc) => bloc.orderState,
                            builder: (context,orderState,_){
                              if(orderState == OrderState.loading){
                                return const Padding(
                                  padding: EdgeInsets.all(18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CupertinoActivityIndicator(),
                                      SizedBox(width: 8),
                                      Text('Uploading')
                                    ],
                                  ),
                                );
                              }else if(orderState == OrderState.success){
                                return const OrderStateWidget(isSuccess: true,tryAgain: null);
                              }
                              else if(orderState == OrderState.error){
                                return OrderStateWidget(
                                    isSuccess: false,
                                    tryAgain: (){
                                      bloc.sendOrderToServer();
                                    });
                              }else{
                                return const SizedBox(height: 16);
                              }
                            }),
                        const SizedBox(height: 16),
                        /// Kitchen Order Screenshot Widget
                        if (widget.orderItems.any((item) => item.mainCategoryId == 1))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScreenshotReceiptWidget(
                                items: widget.orderItems.where((item) => item.mainCategoryId == 1).toList(),
                                screenshotController: screenshotControllerKitchen, // Controller for Kitchen
                                textSize: (printers.isEmpty) ? 8 : printers[0].textSize.toDouble(),
                                printerLocation: KITCHEN,
                                floorName: widget.floorName,
                                tableName: widget.tableName,
                                groupName: widget.groupName.toString(),
                                empName: empName,
                                restaurantName: restaurantName,
                                isCancel: widget.isCancel,
                              ),
                              Selector<PrintReceiptBloc,int>(
                                  selector: (context,bloc) => bloc.kitchenSuccess,
                                  builder: (context,kitchenState,_){
                                    if(kitchenState == 2){
                                      return const SuccessCheckWidget();
                                    }
                                    else if(kitchenState == 3){
                                      return IconButton(onPressed: (){
                                        if(theKitchenImage == null) {
                                          showToastMessage(context, 'Kitchen image is null');
                                          return;
                                        }
                                        _printOrder(1, theKitchenImage!,bloc);
                                      }, icon: const Icon(Icons.refresh,color: Colors.grey,));
                                    }
                                    else if ( kitchenState == 1){
                                      return const LoadingWidget();
                                    }
                                    else {
                                      return const SizedBox(width: 1);
                                    }
                                  })
                            ],
                          ),

                        const SizedBox(height: 16),

                        /// BBQ Screenshot Widget,
                        if (widget.orderItems.any((item) => item.mainCategoryId == 2))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScreenshotReceiptWidget(
                                items: widget.orderItems.where((item) => item.mainCategoryId == 2).toList(),
                                screenshotController: screenshotControllerBBQ, // Controller for BBQ
                                textSize: (printers.isEmpty) ? 8 : printers[1].textSize.toDouble(),
                                printerLocation: BBQ,
                                floorName: widget.floorName,
                                tableName: widget.tableName,
                                groupName: widget.groupName.toString(),
                                empName: empName,
                                restaurantName: restaurantName,
                                isCancel: widget.isCancel,
                              ),
                              Selector<PrintReceiptBloc,int>(
                                  selector: (context,bloc) => bloc.bbqSuccess,
                                  builder: (context,bbqState,_){
                                    if(bbqState == 2){
                                      return const SuccessCheckWidget();
                                    }
                                    else if(bbqState == 3){
                                      return IconButton(onPressed: (){
                                        if(theBBQImage == null) {
                                          showToastMessage(context, 'BBQ image is null');
                                          return;
                                        }
                                        _printOrder(2, theBBQImage!,bloc);
                                      }, icon: const Icon(Icons.refresh,color: Colors.grey,));
                                    }
                                    else if(bbqState == 1){
                                      return const LoadingWidget();
                                    }
                                    else{
                                      return const SizedBox(width: 1);
                                    }
                                  })
                            ],
                          ),

                        const SizedBox(height: 16),

                        // Display the Bar Order Screenshot Widget only if it's in the orderItems
                        if (widget.orderItems.any((item) => item.mainCategoryId == 3))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScreenshotReceiptWidget(
                                items: widget.orderItems.where((item) => item.mainCategoryId == 3).toList(),
                                screenshotController: screenshotControllerBar, // Controller for Bar
                                textSize: (printers.isEmpty) ? 8 : printers[2].textSize.toDouble(),
                                printerLocation: BAR,
                                floorName: widget.floorName,
                                tableName: widget.tableName,
                                groupName: widget.groupName.toString(),
                                empName: empName,
                                restaurantName: restaurantName,
                                isCancel: widget.isCancel,
                              ),
                              Selector<PrintReceiptBloc,int>(
                                  selector: (context,bloc) => bloc.barSuccess,
                                  builder: (context,barState,_){
                                    if(barState == 2){
                                      return const SuccessCheckWidget();
                                    }
                                    else if(barState == 3){
                                      return IconButton(onPressed: (){
                                        if(theBarImage == null) {
                                          showToastMessage(context, 'Bar image is null');
                                          return;
                                        }
                                        _printOrder(3, theBarImage!,bloc);
                                      }, icon: const Icon(Icons.refresh,color: Colors.grey,));
                                    }
                                    else if(barState == 1){
                                      return const LoadingWidget();
                                    }
                                    else{
                                      return const SizedBox(width: 1,);
                                    }
                                  })
                            ],
                          ),

                        const SizedBox(height: 16),

                        /// Counter Screenshot
                        if (widget.orderItems.any((item) => item.mainCategoryId == 4))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScreenshotReceiptWidget(
                                items: widget.orderItems.where((item) => item.mainCategoryId == 4).toList(),
                                screenshotController: screenshotControllerCounter, // Controller for Counter
                                textSize: (printers.isEmpty) ? 8 : printers[3].textSize.toDouble(),
                                printerLocation: COUNTER,
                                floorName: widget.floorName,
                                tableName: widget.tableName,
                                groupName: widget.groupName.toString(),
                                empName: empName,
                                restaurantName: restaurantName,
                                isCancel: widget.isCancel,
                              ),
                              Selector<PrintReceiptBloc,int>(
                                  selector: (context,bloc) => bloc.counterSuccess,
                                  builder: (context,counterState,_){
                                    if(counterState == 2){
                                      return const SuccessCheckWidget();
                                    }
                                    else if(counterState == 3){
                                      return IconButton(onPressed: (){
                                        if(theCounterImage == null) {
                                          showToastMessage(context, 'Counter image is null');
                                          return;
                                        }
                                        _printOrder(4, theBarImage!,bloc);
                                      }, icon: const Icon(Icons.refresh,color: Colors.grey,));
                                    }
                                    else if(counterState == 1){
                                      return const LoadingWidget();
                                    }
                                    else{
                                      return const SizedBox(width: 1);
                                    }
                                  })
                            ],
                          ),

                        const SizedBox(height: 16),

                        (widget.isCancel)
                            ? Selector<PrintReceiptBloc,bool>(
                                selector: (context,bloc) => bloc.clickedCancelPrint,
                                builder: (context,clicked,_){
                                  if(clicked){
                                    return const SizedBox();
                                  }else{
                                    return SizedBox(
                                      width: 200,
                                      child: ElevatedButton.icon(
                                          onPressed: () async {
                                            bloc.clickedCancelPrint = true;
                                            _captureAndPrintOrders(widget.orderItems, bloc);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8))),
                                          icon: const Icon(
                                            Icons.print_outlined,
                                            color: Colors.white70,
                                          ),
                                          label: const Text('Print Order Cancel',
                                              style: TextStyle(color: Colors.white))),
                                    );
                                  }
                                },
                                )
                            : Selector<PrintReceiptBloc,bool>(
                            selector: (context,bloc) => bloc.isClickedPrintAll,
                            builder: (context,isClicked,_){
                              if(isClicked == false){
                                return SizedBox(
                                  width: 200,
                                  child: ElevatedButton.icon(
                                      onPressed: () async{
                                        bloc.sendOrderToServer();
                                        _captureAndPrintOrders(widget.orderItems,bloc);
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
                                      label: const Text('Print All',style: TextStyle(color: Colors.white))),
                                );
                              }
                              else{
                                return const SizedBox(width: 1);
                              }
                            }),
                      ],
                    ),
                  ),
                ),
                Selector<PrintReceiptBloc,OrderState>(
                  selector: (context,bloc) => bloc.orderState,
                  builder: (context,orderState,_){
                    if(orderState == OrderState.success){
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed:(){
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                                  (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Navigate to Main'),
                        ),
                      );
                    }
                    else{
                      return const SizedBox(height: 1);
                    }
                  },
                )
              ],
            )
        );
      },
    );
  }

  void _showSuccessMessage(String printerName) {
    if (mounted) {
      showSuccessScaffoldMessage(context, "Printing success in $printerName");
    }
  }

  void _showAlertDialogMessage(String title, String message) {
    if (mounted) {
      showAlertDialogBox(context, title, message);
    }
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

class SuccessCheckWidget extends StatelessWidget {

  const SuccessCheckWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14),
      child: Icon(Icons.check_circle,color: Colors.green),
    );
  }
}

class OrderStateWidget extends StatelessWidget{
  final bool isSuccess;
  final VoidCallback? tryAgain;
  const OrderStateWidget({super.key, required this.isSuccess, required this.tryAgain});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isSuccess
                  ? const Icon(Icons.check_circle,color: Colors.green,)
                  : IconButton(onPressed: tryAgain, icon: const Icon(Icons.refresh,color: Colors.grey,)),
              const SizedBox(width: 8,),
              Text( isSuccess ? 'New Order Added': 'Check Your Connection!')
            ],
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {

  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14),
      child: CupertinoActivityIndicator(color: Colors.lightBlue),
    );
  }
}
