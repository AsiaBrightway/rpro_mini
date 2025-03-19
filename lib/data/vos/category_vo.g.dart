// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryVo _$CategoryVoFromJson(Map<String, dynamic> json) => CategoryVo(
      (json['category_id'] as num).toInt(),
      json['menu_category_name'] as String,
      (json['main_category_id'] as num).toInt(),
      json['menu_category_image'] as String?,
      (json['store_location_id'] as num?)?.toInt(),
      (json['is_deleted'] as num).toInt(),
      (json['modified_by'] as num?)?.toInt(),
      json['created_at'] as String?,
      json['updated_at'] as String?,
    );

Map<String, dynamic> _$CategoryVoToJson(CategoryVo instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'menu_category_name': instance.categoryName,
      'main_category_id': instance.mainCategoryId,
      'menu_category_image': instance.categoryImage,
      'store_location_id': instance.storeLocationId,
      'is_deleted': instance.isDeleted,
      'modified_by': instance.modifiedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
