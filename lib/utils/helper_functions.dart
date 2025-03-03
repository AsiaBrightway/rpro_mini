import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 170,
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