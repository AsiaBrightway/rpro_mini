
import 'package:json_annotation/json_annotation.dart';
part 'color_request_vo.g.dart';

@JsonSerializable()
class ColorRequestVo{
  @JsonKey(name: 'color_name')
  final String colorName;

  @JsonKey(name: 'color_code')
  final String colorCode;

  ColorRequestVo(this.colorName, this.colorCode);

  factory ColorRequestVo.fromJson(Map<String,dynamic> json) => _$ColorRequestVoFromJson(json);

  Map<String,dynamic> toJson() => _$ColorRequestVoToJson(this);
}