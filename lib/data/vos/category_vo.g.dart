// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryVo _$CategoryVoFromJson(Map<String, dynamic> json) => CategoryVo(
      categoryId: (json['category_id'] as num).toInt(),
      categoryName: json['category_name'] as String,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$CategoryVoToJson(CategoryVo instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'image': instance.image,
      'created_at': instance.createdAt,
    };
