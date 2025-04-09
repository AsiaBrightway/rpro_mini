import 'package:json_annotation/json_annotation.dart';
part 'add_order_item_request.g.dart';

@JsonSerializable()
class AddOrderItemRequest{
  @JsonKey(name: 'orderItemID')
  final int orderItemId;

  @JsonKey(name: 'is_ordered')
  final int isOrdered;

  @JsonKey(name: 'orderItemQuantity')
  final int quantity;

  @JsonKey(name: 'ordered_by')
  final int orderedBy;

  @JsonKey(name: 'price')
  final int price;

  @JsonKey(name: 'orderItemRemark')
  final String remark;

  @JsonKey(name: 'is_foc')
  final int isFoc;

  AddOrderItemRequest(
    this.isFoc, {
      required this.orderedBy,
      required this.price,
      required this.orderItemId,
      required this.isOrdered,
      required this.quantity,
      required this.remark,
  });

  factory AddOrderItemRequest.fromJson(Map<String, dynamic> json) => _$AddOrderItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddOrderItemRequestToJson(this);
}