import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:screenshot/screenshot.dart';

void showSuccessScaffoldMessage(context,String name){
  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
    backgroundColor: Colors.black,
    content: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle,size: 24,color: Colors.green),
          const SizedBox(width: 12),
          Expanded(child: Text(name,style: const TextStyle(fontSize: 15,color: Colors.white)))
        ],
      ),
    ),
    duration: const Duration(milliseconds: 1700),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 170,
      left: 16,
      right: 16,
    ),
    behavior: SnackBarBehavior.floating,
  ));
}

void showScaffoldMessage(context,String name){
  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
    backgroundColor: Colors.grey.shade500,
    content: Text(name,maxLines : 2,style: const TextStyle(fontSize: 15)),
    duration: const Duration(milliseconds: 1700),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: const EdgeInsets.only(
      bottom: 20,
      left: 16,
      right: 16,
    ),
    behavior: SnackBarBehavior.floating,
  ));
}

void showBanner(context,String name){
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      content: Text(name),
      leading: const Icon(Icons.check, color: Colors.green),
      backgroundColor: Colors.white,
      actions: [
        TextButton(
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          child: const Text('DISMISS'),
        ),
      ],
    ),
  );
}

void showAlertDialogBox(BuildContext context,String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(16)
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CLOSE",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      );
    },
  );
}

Future<Uint8List?> captureAndResizeImage(ScreenshotController controller) async {
  // 1) Capture screenshot
  Uint8List? capturedBytes = await controller.capture(delay: const Duration(milliseconds: 100));
  if (capturedBytes == null) return null;

  // 2) Decode the screenshot
  img.Image? decoded = img.decodeImage(capturedBytes);
  if (decoded == null) return null;

  // 3) Encode as PNG (forces RGBA color format)
  final pngBytes = img.encodePng(decoded);

  // 4) Decode again from the PNG bytes
  final standardized = img.decodeImage(pngBytes);
  if (standardized == null) return null;

  // 5) Resize to your desired width
  final resized = img.copyResize(standardized, width: 500);

  // Encode again for printing
  return Uint8List.fromList(img.encodePng(resized));
}

void showDialogBox({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = "OK",
  String cancelText = "Cancel",
  VoidCallback? onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing when tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              if (onConfirm != null) {
                onConfirm();
              }
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}

void showSuccessToast(BuildContext context, String message, {bool isError = false}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
    textColor: Colors.white,
  );
}

void showToastMessage(BuildContext context, String message, {bool isError = false}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey,
    textColor: Colors.white
  );
}