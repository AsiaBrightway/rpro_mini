
import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/color_vo.dart';
import 'package:rpro_mini/data/vos/size_vo.dart';
part 'price_vo.g.dart';

@JsonSerializable()
class PriceVo{
  @JsonKey(name: 'size')
  final SizeVo size;

  @JsonKey(name: 'color')
  final ColorVo color;

  @JsonKey(name: 'price')
  final String price;

  @JsonKey(name: 'stock_qty')
  final String stockQty;

  @JsonKey(name: 'returnPoint')
  final String returnPoint;

  @JsonKey(name: 'is_promotion')
  final int isPromotion;

  @JsonKey(name: 'promotion_price')
  final String? promotionPrice;

  PriceVo(this.size, this.color, this.price, this.stockQty, this.returnPoint,
      this.isPromotion, this.promotionPrice);

  factory PriceVo.fromJson(Map<String, dynamic> json) =>
      _$PriceVoFromJson(json);

  Map<String, dynamic> toJson() => _$PriceVoToJson(this);
}