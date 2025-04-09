
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/request/add_order_item_request.dart';
import 'package:rpro_mini/data/vos/request/add_order_request.dart';
import '../data/vos/order_details_vo.dart';
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
  int _tableId = 0;
  int _userId = 0;
  int _orderNumberValue = 0;
  bool _clickedCancelPrint = false;
  List<OrderDetailsVo> _orderItems = [];
  OrderState _orderState = OrderState.initial;
  final ShoppyAdminModel _model = ShoppyAdminModel();

  bool get clickedCancelPrint => _clickedCancelPrint;
  OrderState get orderState => _orderState;
  bool get isClickedPrintAll => _isClickedPrintAll;
  int get bbqSuccess => _bbqSuccess;
  int get kitchenSuccess => _kitchenSuccess;
  int get barSuccess => _barSuccess;
  int get counterSuccess => _counterSuccess;


  set clickedCancelPrint(bool value) {
    _clickedCancelPrint = value;
    notifyListeners();
  }

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

  PrintReceiptBloc(int tableId,int orderNumber,List<OrderDetailsVo> orderItems,int userId){
    _tableId = tableId;
    _userId = userId;
    _orderNumberValue = orderNumber;
    _orderItems = orderItems;
  }

  void changePrintState(String name,int state){
    if(name == KITCHEN) {
      _kitchenSuccess = state;
    } else if(name == BBQ) {
      _bbqSuccess = state;
    }
    else if(name == BAR) {
      _barSuccess = state;
    }
    else if(name == COUNTER) {
      _counterSuccess = state;
    }
    notifyListeners();
  }

  Future<void> sendOrderToServer() async{
    _orderState = OrderState.loading;
    notifyListeners();
    var newOrder = getOrderRequest();
    _model.addOrderItem(newOrder).then((onValue){
      _orderState = OrderState.success;
      notifyListeners();
    }).catchError((onError){
      _orderState = OrderState.error;
      notifyListeners();
    });
  }

  AddOrderRequest getOrderRequest(){
    List<AddOrderItemRequest> requestItems = [];
    for(final item in _orderItems){
      requestItems.add(
        AddOrderItemRequest(
          0,
          quantity: item.quantity,
          remark: item.remark ?? '',
          orderedBy: _userId,
          price: int.parse(item.itemPrice),
          orderItemId: item.itemId,
          isOrdered: 0
        ),
      );
    }
    return AddOrderRequest(
      _tableId,
      _orderNumberValue,
      requestItems
    );
  }
}