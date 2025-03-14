import 'package:json_annotation/json_annotation.dart';
part 'table_vo.g.dart';

@JsonSerializable()
class TableVo{
  @JsonKey(name: 'table_id')
  final int tableId;

  @JsonKey(name: 'table_name')
  final String tableName;

  @JsonKey(name: 'floor_id')
  final int floorId;

  @JsonKey(name: 'is_open')
  final int isOpen;

  TableVo(this.tableId, this.tableName, this.floorId, this.isOpen);

  factory TableVo.fromJson(Map<String,dynamic> json) => _$TableVoFromJson(json);

  Map<String,dynamic> toJson() => _$TableVoToJson(this);
}