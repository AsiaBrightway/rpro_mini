
import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse{
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'menuCategories')
  final List<CategoryVo> data;

  CategoryResponse(this.message, this.data);

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}