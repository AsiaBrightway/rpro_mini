import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/brand_vo.dart';
part 'brand_response.g.dart';

@JsonSerializable()
class BrandResponse{
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<BrandVo> data;

  BrandResponse(this.message, {required this.data});

  factory BrandResponse.fromJson(Map<String, dynamic> json) =>
      _$BrandResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BrandResponseToJson(this);
}