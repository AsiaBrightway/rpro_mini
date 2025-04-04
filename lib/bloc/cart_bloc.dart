
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rpro_mini/bloc/add_order_bloc.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/order_details_vo.dart';
import 'package:rpro_mini/utils/helper_functions.dart';

class CartBloc extends ChangeNotifier{

  String errorMessage = '';
  ItemState _itemState = ItemState.initial;
  List<OrderDetailsVo> _orderDetailsList = [];
  final ShoppyAdminModel _model = ShoppyAdminModel();
  List<OrderDetailsVo> newOrderItems = [];
  List<OrderDetailsVo> combinedOrderItems = [];
  ItemState get itemState => _itemState;
  List<OrderDetailsVo> get orderDetailsList => _orderDetailsList;
  int _tableId = 1;
  int _selectedGroup = 1; // Using int instead of String
  final List<int> _availableGroups = [1, 2, 3, 4, 5];

  int get selectedGroup => _selectedGroup;
  List<int> get availableGroups => _availableGroups;

  CartBloc(List<OrderDetailsVo> newItems,int group,int tableId) {
    newOrderItems = newItems;
    _tableId = tableId;
    _selectedGroup = group;
    getOrderDetails();
  }

  void changeGroup(int group) {
    _selectedGroup = group;
    getOrderDetails();
    notifyListeners();
  }

  Future<void> getOrderDetails() async {
    _itemState = ItemState.loading;
    notifyListeners();
    _model.getOrderDetailsByTable(_tableId, selectedGroup).then((onValue) {
      _orderDetailsList = onValue.orderDetails ?? [];
      _itemState = ItemState.success;
      combinedOrderItems = [..._orderDetailsList, ...newOrderItems];
      notifyListeners();
    }).catchError((onError) {
      _itemState = ItemState.error;
      errorMessage = onError.toString();
      notifyListeners();
    });
  }

  void _updateItemQuantity(int itemId, int newQuantity) {
    // Try to find in _orderDetailsList first
    final orderDetailsIndex = combinedOrderItems.indexWhere((item) => item.itemId == itemId && item.isOrdered == 0);
    if (orderDetailsIndex >= 0) {
      combinedOrderItems[orderDetailsIndex].quantity = newQuantity;

      // TRICK: Reassign the list to itself to force Selector to update
      //combinedOrderItems = combinedOrderItems;
      notifyListeners();
    }
  }

  void incrementQuantity(int itemId) {
    final item = combinedOrderItems.firstWhere((item) => item.itemId == itemId && item.isOrdered == 0);
    _updateItemQuantity(itemId, item.quantity + 1);
    notifyListeners();

  }

  void decrementQuantity(int itemId) {
    final item = combinedOrderItems.firstWhere((item) => item.itemId == itemId && item.isOrdered == 0);
    if (item.quantity > 1) {
      _updateItemQuantity(itemId, item.quantity - 1);
      notifyListeners();

    }
  }

  void updateQuantity(int itemId, int newQuantity) {
    if (newQuantity < 1) return;
    _updateItemQuantity(itemId, newQuantity);
    notifyListeners();

  }

  void updateRemark(int itemId,String newRemark){
    final orderDetailsIndex = combinedOrderItems.indexWhere((item) => item.itemId == itemId && item.isOrdered == 0);
    if (orderDetailsIndex >= 0) {
      combinedOrderItems[orderDetailsIndex].remark = newRemark;

      notifyListeners();
    }
  }

  Future<void> removeItem(OrderDetailsVo item,BuildContext context,VoidCallback onSuccess) async{
    if(item.orderId == 0){
      newOrderItems.removeWhere((i) => i.itemId == item.itemId && i.isOrdered == 0);
      combinedOrderItems = [..._orderDetailsList, ...newOrderItems];
      notifyListeners();
    }else{
      _model.deleteOrderItem(item.orderDetailsId).then((onValue){
        showSuccessToast(context, onValue.message.toString());
        getOrderDetails();
        onSuccess();
      }).catchError((onError){
        showScaffoldMessage(context, 'Unable to delete. Check connection');
      });
    }
  }
}