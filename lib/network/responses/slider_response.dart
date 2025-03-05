import 'package:json_annotation/json_annotation.dart';
import '../../data/vos/slider_vo.dart';
part 'slider_response.g.dart';

@JsonSerializable()
class SliderResponse{
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<SliderVo> data;

  SliderResponse(this.message, this.data);

  factory SliderResponse.fromJson(Map<String, dynamic> json) =>
      _$SliderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SliderResponseToJson(this);
}