
import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/request/price_request_vo.dart';
import 'package:rpro_mini/data/vos/request/product_image_request.dart';
part 'product_request_vo.g.dart';

@JsonSerializable()
class ProductRequestVo{
  @JsonKey(name: 'sub_category_id')
  final int subCategoryId;

  @JsonKey(name: 'brand_id')
  final int brandId;

  @JsonKey(name: 'product_name')
  final String productName;

  @JsonKey(name: 'product_description')
  final String description;

  @JsonKey(name: 'productImages')
  final List<ProductImageRequest>? productImages;

  @JsonKey(name: 'productPrices')
  final List<PriceRequestVo>? productPrices;

  ProductRequestVo(this.subCategoryId, this.brandId, this.productName,
      this.description, this.productPrices, this.productImages);

  factory ProductRequestVo.fromJson(Map<String,dynamic> json) => _$ProductRequestVoFromJson(json);

  Map<String,dynamic> toJson() => _$ProductRequestVoToJson(this);
}