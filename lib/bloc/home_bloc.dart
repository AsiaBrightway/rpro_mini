
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import '../data/vos/table_vo.dart';

class HomeBloc extends ChangeNotifier{

  final ShoppyAdminModel _model = ShoppyAdminModel();
  List<FloorVo> _floors = [];
  List<TableVo> _tables = [TableVo(1,"T003",1,1), TableVo(2,"T001",1,1), TableVo(3,"T005",1,1), TableVo(4,"T007",1,1),];
  List<FloorVo> get floors => _floors;
  List<TableVo> get tables => _tables;
  String? selectedFloor;

  set tables(List<TableVo> value) {
    _tables = value;
    notifyListeners();
  }

  set floors(List<FloorVo> value) {
    _floors = value;
    notifyListeners();
  }

  HomeBloc(){
    fetchFloors();
  }

  Future<void> fetchFloors() async {
    _model.getFloors().then((onValue){
      _floors = onValue;
      selectedFloor = _floors.first.floorName;
      notifyListeners();
    }).catchError((onError){

    });

    notifyListeners(); // Notify listeners when floors are updated
  }

  Future<void> fetchTables(int floorId) async {
    // Simulate fetching tables based on floorId
    _tables = [
      TableVo( 1, "Table A",1,1),
      TableVo( 2, "Table B",0,0),
    ];
    notifyListeners();
  }
}