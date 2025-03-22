import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/table_vo.dart';
import '../../data/vos/order_details_vo.dart';
part 'order_details_response.g.dart';

@JsonSerializable()
class OrderDetailsResponse{

  @JsonKey(name: 'tableOrderValue')
  final String? tableOrderValue;

  @JsonKey(name: 'table')
  final TableVo? table;

  @JsonKey(name: 'orderID')
  final int? orderId;

  @JsonKey(name: 'orderDetails')
  final List<OrderDetailsVo>? orderDetails;

  OrderDetailsResponse(
      this.tableOrderValue, this.table, this.orderId, this.orderDetails);

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsResponseToJson(this);
}