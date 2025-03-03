// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductVo _$ProductVoFromJson(Map<String, dynamic> json) => ProductVo(
      (json['product_id'] as num).toInt(),
      json['product_name'] as String,
      json['product_description'] as String,
      CategoryVo.fromJson(json['category'] as Map<String, dynamic>),
      SubCategoryVo.fromJson(json['sub_category'] as Map<String, dynamic>),
      BrandVo.fromJson(json['brand'] as Map<String, dynamic>),
      (json['images'] as List<dynamic>?)
          ?.map((e) => ProductImageVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['created_at'] as String?,
      (json['productPrices'] as List<dynamic>?)
          ?.map((e) => PriceVo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductVoToJson(ProductVo instance) => <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_description': instance.description,
      'category': instance.category,
      'sub_category': instance.subCategory,
      'brand': instance.brand,
      'images': instance.images,
      'created_at': instance.createdAt,
      'productPrices': instance.prices,
    };
