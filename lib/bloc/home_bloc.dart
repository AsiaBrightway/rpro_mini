
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/vos/table_vo.dart';

class HomeBloc extends ChangeNotifier{

  List<String> _floors = ['First Floor','Second Floor','3rd','4th Floor'];
  List<TableVo> _tables = [TableVo(1,"T003"), TableVo(2,"T001"), TableVo(3,"T005"), TableVo(4,"T007"),];

  List<String> get floors => _floors;
  List<TableVo> get tables => _tables;

  set tables(List<TableVo> value) {
    _tables = value;
    notifyListeners();
  }

  set floors(List<String> value) {
    _floors = value;
    notifyListeners();
  }

  HomeBloc(){

  }


}