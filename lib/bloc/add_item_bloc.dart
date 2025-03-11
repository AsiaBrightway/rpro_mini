
import 'package:flutter/material.dart';

class AddItemBloc extends ChangeNotifier{

  List<String> _items = ['Beer','Milk','Tiger','Dagon'];
  List<String> categories = ['Myanmar Beer','Noodle','အကင်များ','ထမင်းကြော်','အကြော်များ'];

  List<String> get items => _items;

  set items(List<String> value) {
    _items = value;
    notifyListeners();
  }

  Future<void> onTapCategory(int id) async{

  }
}