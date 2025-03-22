
import 'package:flutter/material.dart';
import 'package:rpro_mini/bloc/add_order_bloc.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/order_details_vo.dart';

class CartBloc extends ChangeNotifier{

  String errorMessage = '';
  ItemState _itemState = ItemState.initial;
  List<OrderDetailsVo> _orderDetailsList = [];
  ShoppyAdminModel _model = ShoppyAdminModel();

  ItemState get itemState => _itemState;
  List<OrderDetailsVo> get orderDetailsList => _orderDetailsList;

  CartBloc(){
    getOrderDetails();
  }

  Future<void> getOrderDetails() async{
    _itemState = ItemState.loading;
    notifyListeners();
    _model.getOrderDetailsByTable(1, 1).then((onValue){
      _orderDetailsList = onValue.orderDetails ?? [];
      _itemState = ItemState.success;
      notifyListeners();
    }).catchError((onError){
      _itemState = ItemState.error;
      errorMessage = onError.toString();
      notifyListeners();
    });
  }
}