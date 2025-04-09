
import 'package:json_annotation/json_annotation.dart';
import 'add_order_item_request.dart';
part 'add_order_request.g.dart';

@JsonSerializable()
class AddOrderRequest{

  @JsonKey(name: 'tableID')
  final int tableId;

  @JsonKey(name: 'tableOrderNumber')
  final int tableOrderNumber;

  @JsonKey(name: 'unOrderItems')
  final List<AddOrderItemRequest> orderItems;

  AddOrderRequest(this.tableId, this.tableOrderNumber, this.orderItems);

  factory AddOrderRequest.fromJson(Map<String,dynamic> json) => _$AddOrderRequestFromJson(json);

  Map<String,dynamic> toJson() => _$AddOrderRequestToJson(this);
}