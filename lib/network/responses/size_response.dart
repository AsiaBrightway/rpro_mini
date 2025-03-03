
import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/size_vo.dart';
part 'size_response.g.dart';

@JsonSerializable()
class SizeResponse{

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<SizeVo>? data;

  SizeResponse(this.message, {required this.data});

  factory SizeResponse.fromJson(Map<String, dynamic> json) =>
      _$SizeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SizeResponseToJson(this);
}