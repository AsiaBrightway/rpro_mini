import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/table_vo.dart';
part 'table_data_vo.g.dart';

@JsonSerializable()
class TableDataVo{
  @JsonKey(name: 'tables')
  final List<TableVo>? tables;

  @JsonKey(name: 'occupiedTables')
  final List<int>? occupiedTables;

  @JsonKey(name: 'reservationTables')
  final List<int>? reservationTables;

  TableDataVo(this.tables, this.occupiedTables, this.reservationTables);

  factory TableDataVo.fromJson(Map<String,dynamic> json) => _$TableDataVoFromJson(json);

  Map<String,dynamic> toJson() => _$TableDataVoToJson(this);

}