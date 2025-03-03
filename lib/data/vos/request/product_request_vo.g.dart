// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_request_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductRequestVo _$ProductRequestVoFromJson(Map<String, dynamic> json) =>
    ProductRequestVo(
      (json['sub_category_id'] as num).toInt(),
      (json['brand_id'] as num).toInt(),
      json['product_name'] as String,
      json['product_description'] as String,
      (json['productPrices'] as List<dynamic>?)
          ?.map((e) => PriceRequestVo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['productImages'] as List<dynamic>?)
          ?.map((e) => ProductImageRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductRequestVoToJson(ProductRequestVo instance) =>
    <String, dynamic>{
      'sub_category_id': instance.subCategoryId,
      'brand_id': instance.brandId,
      'product_name': instance.productName,
      'product_description': instance.description,
      'productImages': instance.productImages,
      'productPrices': instance.productPrices,
    };
