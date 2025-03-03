
import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/sub_category_vo.dart';
part 'sub_category_response.g.dart';

@JsonSerializable()
class SubCategoryResponse{
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<SubCategoryVo> data;

  SubCategoryResponse(this.message, {required this.data});

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryResponseToJson(this);
}