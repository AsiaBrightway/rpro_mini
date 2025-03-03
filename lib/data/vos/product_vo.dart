
import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/data/vos/brand_vo.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
import 'package:rpro_mini/data/vos/price_vo.dart';
import 'package:rpro_mini/data/vos/product_image_vo.dart';
import 'package:rpro_mini/data/vos/sub_category_vo.dart';

import '../../fcm/access_firebase_token.dart';
part 'product_vo.g.dart';

@JsonSerializable()
class ProductVo{
  @JsonKey(name: 'product_id')
  final int productId;

  @JsonKey(name: 'product_name')
  final String productName;

  @JsonKey(name: 'product_description')
  final String description;

  @JsonKey(name: 'category')
  final CategoryVo category;

  @JsonKey(name: 'sub_category')
  final SubCategoryVo subCategory;

  @JsonKey(name: 'brand')
  final BrandVo brand;

  @JsonKey(name: 'images')
  final List<ProductImageVo>? images;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'productPrices')
  final List<PriceVo>? prices;

  ProductVo(this.productId, this.productName, this.description, this.category,
      this.subCategory, this.brand, this.images, this.createdAt, this.prices);

  factory ProductVo.fromJson(Map<String, dynamic> json) =>
      _$ProductVoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (images?.first.image ?? "");
  }
}