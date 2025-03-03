
import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/product_vo.dart';
part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse{
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<ProductVo>? products;

  ProductResponse(this.message, this.products);

  factory ProductResponse.fromJson(Map<String,dynamic> json) => _$ProductResponseFromJson(json);

  Map<String,dynamic> toJson() => _$ProductResponseToJson(this);
}