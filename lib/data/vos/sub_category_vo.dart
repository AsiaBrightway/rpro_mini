
import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';
import 'category_vo.dart';

part 'sub_category_vo.g.dart';

@JsonSerializable()
class SubCategoryVo {
  @JsonKey(name: 'sub_category_id')
  final int subCategoryId;

  @JsonKey(name: 'sub_category_name')
  final String subCategoryName;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'category')
  final CategoryVo? category;

  SubCategoryVo(this.category, this.updatedAt, {
    required this.subCategoryId,
    required this.subCategoryName,
    this.image,
    required this.createdAt,
  });

  factory SubCategoryVo.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryVoFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (image ?? "");
  }
}