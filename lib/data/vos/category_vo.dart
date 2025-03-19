
import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';
part 'category_vo.g.dart';

@JsonSerializable()
class CategoryVo {
  @JsonKey(name: 'category_id')
  final int categoryId;

  @JsonKey(name: 'menu_category_name')
  final String categoryName;

  @JsonKey(name: 'main_category_id')
  final int mainCategoryId;

  @JsonKey(name: 'menu_category_image')
  final String? categoryImage; // Nullable field

  @JsonKey(name: 'store_location_id')
  final int? storeLocationId;

  @JsonKey(name: 'is_deleted')
  final int isDeleted;

  @JsonKey(name: 'modified_by')
  final int? modifiedBy;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  CategoryVo(
      this.categoryId,
      this.categoryName,
      this.mainCategoryId,
      this.categoryImage,
      this.storeLocationId,
      this.isDeleted,
      this.modifiedBy,
      this.createdAt,
      this.updatedAt);

  factory CategoryVo.fromJson(Map<String, dynamic> json) =>
      _$CategoryVoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (categoryImage ?? "");
  }
}