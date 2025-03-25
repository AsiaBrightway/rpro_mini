import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import '../data/vos/table_vo.dart';

enum TableState { initial, loading, success, error }

class HomeBloc extends ChangeNotifier{

  final ShoppyAdminModel _model = ShoppyAdminModel();
  TableState _tableState = TableState.initial;
  String? _tableErrorMessage;
  List<FloorVo> _floors = [];
  List<TableVo> _tables = [];
  List<int> occupiedTables = [];
  List<int> reservationTables = [];
  List<FloorVo> get floors => _floors;
  List<TableVo> get tables => _tables;
  String? selectedFloor;

  TableState get tableState => _tableState;
  String? get tableErrorMessage => _tableErrorMessage;

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
    _tableState = TableState.loading;
    notifyListeners();
    _model.getFloors().then((onValue){
      _floors = onValue;
      fetchTables(_floors.first.floorId);
      selectedFloor = _floors.first.floorName;
      notifyListeners();
    }).catchError((onError){
      _tableState = TableState.error;
      _tableErrorMessage = 'Check you connection';
      notifyListeners();
    });

    notifyListeners(); // Notify listeners when floors are updated
  }

  Future<void> fetchTables(int floorId) async {
    _tableState = TableState.loading;
    _model.getTablesByFloorId(floorId).then((response){
      _tables = response.data.tables ?? [];
      _tableState = TableState.success;
      _tableErrorMessage = null;
      reservationTables = response.data.reservationTables ?? [];
      occupiedTables = response.data.occupiedTables ?? [];
      notifyListeners();
    }).catchError((error){
      _tableState = TableState.error;
      _tableErrorMessage = error.toString();
      notifyListeners();
    });
  }
}