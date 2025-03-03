// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_request_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceRequestVo _$PriceRequestVoFromJson(Map<String, dynamic> json) =>
    PriceRequestVo(
      sizeId: json['size_id'] as String,
      colorId: json['color_id'] as String,
      price: (json['price'] as num).toDouble(),
      stockQty: (json['stock_qty'] as num).toInt(),
      returnPoints: (json['return_points'] as num).toInt(),
      isPromotion: json['is_promotion'] as bool,
      promotionPrice: (json['promotion_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PriceRequestVoToJson(PriceRequestVo instance) =>
    <String, dynamic>{
      'size_id': instance.sizeId,
      'color_id': instance.colorId,
      'price': instance.price,
      'stock_qty': instance.stockQty,
      'return_points': instance.returnPoints,
      'is_promotion': instance.isPromotion,
      'promotion_price': instance.promotionPrice,
    };
