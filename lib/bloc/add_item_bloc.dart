
import 'package:flutter/material.dart';

class AddItemBloc extends ChangeNotifier{

  List<String> _items = ['Beer','Milk','Tiger','Dagon'];

  List<String> get items => _items;

  set items(List<String> value) {
    _items = value;
    notifyListeners();
  }
}