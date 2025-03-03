import 'package:json_annotation/json_annotation.dart';
part 'color_vo.g.dart';

@JsonSerializable()
class ColorVo{
  @JsonKey(name: 'color_id')
  final int colorId;

  @JsonKey(name: 'color_name')
  final String colorName;

  @JsonKey(name: 'color_code')
  final String colorCode;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  ColorVo(this.colorId, this.colorName, this.colorCode, this.createdAt);

  factory ColorVo.fromJson(Map<String,dynamic> json) => _$ColorVoFromJson(json);

  Map<String,dynamic> toJson() => _$ColorVoToJson(this);
}