
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
import 'package:rpro_mini/data/vos/item_vo.dart';
import 'package:rxdart/rxdart.dart';

enum ItemState { initial, loading, success, error }

class AddOrderBloc extends ChangeNotifier{

  bool _isSearching = false;
  ItemState _itemState = ItemState.initial;
  List<CategoryVo> categories = [];
  List<ItemVo> _items = [];
  final ShoppyAdminModel _model = ShoppyAdminModel();
  String selectedCategory = '';
  StreamController<String> queryStreamController = StreamController();

  ItemState get itemState => _itemState;
  bool get isSearching => _isSearching;
  List<ItemVo> get items => _items;

  set items(List<ItemVo> value) {
    _items = value;
    notifyListeners();
  }

  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  AddOrderBloc(){
    getCategories();
    queryStreamController.stream.debounceTime(const Duration(milliseconds: 500)).listen((query){
      if(query.isNotEmpty){
        searchItemByName(query);
      }
    });
  }

  Future<void> onTapCategory(String id) async{
    selectedCategory = id;
    final category = categories.firstWhere(
          (category) => category.categoryName == selectedCategory);
    getItemsByCategory(category.categoryId);
    notifyListeners();
  }

  Future<void> getCategories() async{
    _model.getCategories().then((onValue){
      categories = onValue;
      selectedCategory = onValue.first.categoryName;
      getItemsByCategory(categories.first.categoryId);
       notifyListeners();
    }).catchError((onError){

    });
  }

  Future<void> searchItemByName(String name) async{
    _itemState = ItemState.loading;
    notifyListeners();
    _model.searchItemByName(name).then((onValue){
      _items =  onValue ?? [];
      _itemState = ItemState.success;
      notifyListeners();
    }).catchError((onError){
      _itemState = ItemState.error;
      notifyListeners();
    });
  }

  Future<void> getItemsByCategory(int categoryId) async{
    _model.getItemsByCategory(categoryId).then((onValue){
      _items = onValue ?? [];
      notifyListeners();
    }).catchError((onError){

    });
  }
}