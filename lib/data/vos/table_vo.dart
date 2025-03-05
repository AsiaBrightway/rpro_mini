import 'package:json_annotation/json_annotation.dart';
part 'table_vo.g.dart';

@JsonSerializable()
class TableVo{
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  TableVo(this.id, this.name);

  factory TableVo.fromJson(Map<String,dynamic> json) => _$TableVoFromJson(json);

  Map<String,dynamic> toJson() => _$TableVoToJson(this);
}