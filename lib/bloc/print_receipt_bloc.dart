
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../network/api_constants.dart';

enum OrderState { initial, loading, success, error }

class PrintReceiptBloc extends ChangeNotifier{
  /// 0 is initial ,
  /// 1 is loading ,
  /// 2 is success ✅ ,
  /// 3 is fail ❌
  int _kitchenSuccess = 0;
  int _bbqSuccess = 0;
  int _barSuccess = 0;
  int _counterSuccess = 0;
  bool _isClickedPrintAll = false;
  OrderState _orderState = OrderState.initial;

  OrderState get orderState => _orderState;
  bool get isClickedPrintAll => _isClickedPrintAll;
  int get bbqSuccess => _bbqSuccess;
  int get kitchenSuccess => _kitchenSuccess;
  int get barSuccess => _barSuccess;
  int get counterSuccess => _counterSuccess;

  set orderState(OrderState value) {
    _orderState = value;
    notifyListeners();
  }

  set bbqSuccess(int value) {
    _bbqSuccess = value;
  }

  set barSuccess(int value) {
    _barSuccess = value;
  }

  set isClickedPrintAll(bool value) {
    _isClickedPrintAll = value;
    notifyListeners();
  }

  set counterSuccess(int value) {
    _counterSuccess = value;
    notifyListeners();
  }

  set kitchenSuccess(int value) {
    _kitchenSuccess = value;
    notifyListeners();
  }

  PrintReceiptBloc(){

  }

  void changePrintState(String name,int state){
    if(name == KITCHEN) {
      _kitchenSuccess = state;
    } else if(name == BBQ) {
      _bbqSuccess = state;
    }
    else if(name == BAR) {
      _barSuccess == state;
    }
    else if(name == COUNTER) {
      _counterSuccess = state;
    }
    notifyListeners();
  }

  Future<void> sendOrderToServer() async{
    _orderState = OrderState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    _orderState = OrderState.success;
    notifyListeners();
  }
}