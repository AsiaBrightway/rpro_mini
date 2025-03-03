import 'package:json_annotation/json_annotation.dart';
import '../../data/vos/color_vo.dart';
part 'color_response.g.dart';

@JsonSerializable()
class ColorResponse {

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<ColorVo> data;

  ColorResponse(this.message, {required this.data});

  factory ColorResponse.fromJson(Map<String, dynamic> json) =>
      _$ColorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ColorResponseToJson(this);
}
