// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceVo _$PriceVoFromJson(Map<String, dynamic> json) => PriceVo(
      SizeVo.fromJson(json['size'] as Map<String, dynamic>),
      ColorVo.fromJson(json['color'] as Map<String, dynamic>),
      json['price'] as String,
      json['stock_qty'] as String,
      json['returnPoint'] as String,
      (json['is_promotion'] as num).toInt(),
      json['promotion_price'] as String?,
    );

Map<String, dynamic> _$PriceVoToJson(PriceVo instance) => <String, dynamic>{
      'size': instance.size,
      'color': instance.color,
      'price': instance.price,
      'stock_qty': instance.stockQty,
      'returnPoint': instance.returnPoint,
      'is_promotion': instance.isPromotion,
      'promotion_price': instance.promotionPrice,
    };
