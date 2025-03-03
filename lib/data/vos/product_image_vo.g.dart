// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductImageVo _$ProductImageVoFromJson(Map<String, dynamic> json) =>
    ProductImageVo(
      productImageId: (json['product_image_id'] as num).toInt(),
      image: json['image'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ProductImageVoToJson(ProductImageVo instance) =>
    <String, dynamic>{
      'product_image_id': instance.productImageId,
      'image': instance.image,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
