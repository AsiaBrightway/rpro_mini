
import 'package:flutter/material.dart';

class AddItemBloc extends ChangeNotifier{

  List<String> _items = ['Beer','Milk','Tiger','Dagon'];

  String selectedCategory = 'Myanmar Beer';
  List<String> get items => _items;
  List<String> categories = [];
  set items(List<String> value) {
    _items = value;
    notifyListeners();
  }

  AddItemBloc(){
    categories = ['Myanmar Beer','Noodle','အကင်များ','ထမင်းကြော်','အကြော်များ'];
    selectedCategory = categories.first;
  }

  Future<void> onTapCategory(String id) async{
    categories = ['Myanmar Beer','Noodle','အကင်များ','ထမင်းကြော်','အကြော်များ'];
    selectedCategory = id;
    notifyListeners();
  }
}