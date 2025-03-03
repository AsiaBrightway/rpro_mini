// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandVo _$BrandVoFromJson(Map<String, dynamic> json) => BrandVo(
      brandId: (json['brand_id'] as num).toInt(),
      brandName: json['brand_name'] as String,
      brandDescription: json['brand_description'] as String,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$BrandVoToJson(BrandVo instance) => <String, dynamic>{
      'brand_id': instance.brandId,
      'brand_name': instance.brandName,
      'brand_description': instance.brandDescription,
      'image': instance.image,
      'created_at': instance.createdAt,
    };
