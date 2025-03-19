import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/table_data_vo.dart';
part 'table_response.g.dart';

@JsonSerializable()
class TableResponse{
  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final TableDataVo data;

  TableResponse(this.status, this.message, this.data);

  factory TableResponse.fromJson(Map<String,dynamic> json) => _$TableResponseFromJson(json);

  Map<String,dynamic> toJson() => _$TableResponseToJson(this);
}