// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategoryVo _$SubCategoryVoFromJson(Map<String, dynamic> json) =>
    SubCategoryVo(
      json['category'] == null
          ? null
          : CategoryVo.fromJson(json['category'] as Map<String, dynamic>),
      json['updated_at'] as String?,
      subCategoryId: (json['sub_category_id'] as num).toInt(),
      subCategoryName: json['sub_category_name'] as String,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$SubCategoryVoToJson(SubCategoryVo instance) =>
    <String, dynamic>{
      'sub_category_id': instance.subCategoryId,
      'sub_category_name': instance.subCategoryName,
      'image': instance.image,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'category': instance.category,
    };
