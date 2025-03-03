
import 'package:json_annotation/json_annotation.dart';
part 'price_request_vo.g.dart';

@JsonSerializable()
class PriceRequestVo{

  @JsonKey(name: 'size_id')
  final String sizeId;

  @JsonKey(name: 'color_id')
  final String colorId;

  final double price;

  @JsonKey(name: 'stock_qty')
  final int stockQty;

  @JsonKey(name: 'return_points')
  final int returnPoints;

  @JsonKey(name: 'is_promotion')
  final bool isPromotion;

  @JsonKey(name: 'promotion_price')
  final double? promotionPrice;

  PriceRequestVo({
    required this.sizeId,
    required this.colorId,
    required this.price,
    required this.stockQty,
    required this.returnPoints,
    required this.isPromotion,
    this.promotionPrice,
  });

  factory PriceRequestVo.fromJson(Map<String, dynamic> json) =>
      _$PriceRequestVoFromJson(json);

  Map<String, dynamic> toJson() => _$PriceRequestVoToJson(this);
}