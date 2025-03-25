import 'package:json_annotation/json_annotation.dart';
part 'order_details_vo.g.dart';

@JsonSerializable()
class OrderDetailsVo {
  @JsonKey(name: 'order_detail_id')
  final int orderDetailsId;

  @JsonKey(name: 'order_id')
  final int orderId;

  @JsonKey(name: 'item_id')
  final int itemId;

  @JsonKey(name: 'main_category_id')
  final int? mainCategoryId;

  @JsonKey(name: 'batch_number')
  final int? batchNumber;

  @JsonKey(name: 'promotion_price')
  final String? promotionPrice;

  @JsonKey(name: 'quantity')
  int quantity;

  @JsonKey(name: 'remark')
  String? remark;

  @JsonKey(name: 'is_ordered')
  final int? isOrdered;

  @JsonKey(name: 'is_foc')
  final int? isFoc;

  @JsonKey(name: 'order_type')
  final int? orderType;

  @JsonKey(name: 'ordered_by')
  final int? orderedBy;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'item_price')
  final String itemPrice;

  @JsonKey(name: 'item_name')
  final String itemName;

  @JsonKey(name: 'item_image')
  final String? itemImage;

  OrderDetailsVo(
      this.orderDetailsId,
      this.orderId,
      this.itemId,
      this.batchNumber,
      this.promotionPrice,
      this.quantity,
      this.remark,
      this.isOrdered,
      this.isFoc,
      this.orderType,
      this.orderedBy,
      this.createdAt,
      this.updatedAt, this.itemPrice, this.itemName, this.itemImage, this.mainCategoryId);

  factory OrderDetailsVo.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsVoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsVoToJson(this);
}