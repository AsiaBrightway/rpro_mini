
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
import 'package:rpro_mini/data/vos/item_vo.dart';
import 'package:rpro_mini/data/vos/order_details_vo.dart';
import 'package:rxdart/rxdart.dart';

enum ItemState { initial, loading, success, error }

class AddOrderBloc extends ChangeNotifier{

  /// true is success,
  /// false is fail,
  /// null loading
  bool _isSearching = false;
  ItemState _itemState = ItemState.initial;
  List<CategoryVo> categories = [];
  List<ItemVo> _items = [];
  final ShoppyAdminModel _model = ShoppyAdminModel();
  String selectedCategory = '';
  StreamController<String> queryStreamController = StreamController();
  List<OrderDetailsVo> orderDetails = [];
  ItemState get itemState => _itemState;
  bool get isSearching => _isSearching;
  List<ItemVo> get items => _items;
  bool isAdd = false;

  int _selectedGroup = 1;
  final List<int> _availableGroups = [1, 2, 3, 4, 5];

  int get selectedGroup => _selectedGroup;
  List<int> get availableGroups => _availableGroups;

  void changeGroup(int group) {
    _selectedGroup = group;
    notifyListeners();
  }

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


  void addOrUpdateOrderItem(int itemId) {

    ItemVo item = filterItemById(itemId);
    isAdd = true;
    notifyListeners();
    bool itemExists = false;
    for (var orderDetail in orderDetails) {
      if (orderDetail.itemId == itemId) {
        // Item exists, increase the quantity
        orderDetail.quantity = (orderDetail.quantity + 1);
        itemExists = true;
        break;
      }
    }

    // If the item does not exist, add it to the list
    if (!itemExists) {
      orderDetails = List.from(orderDetails)
        ..add(
          OrderDetailsVo(
            0,
            0,
            itemId,
            null,
            null,
            1,
            "",
            0,
            0,
            null,
            null,
            null,
            null,
            item.price!,
            item.itemName ?? '',
            item.image ?? '',
            item.mainCategoryId,
            item.unitName
          ));
      notifyListeners();
    }
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

  ItemVo filterItemById(int itemId) {
    // Use the `where` method to filter the list
    var filteredItems = _items.where((item) => item.itemId == itemId).first;
    return filteredItems;
  }
}