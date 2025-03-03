import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';

part 'product_image_vo.g.dart';

@JsonSerializable()
class ProductImageVo {
  @JsonKey(name: 'product_image_id')
  final int productImageId;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'created_at')
  final String? createdAt; // Nullable field

  @JsonKey(name: 'updated_at')
  final String? updatedAt; // Nullable field

  ProductImageVo({
    required this.productImageId,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductImageVo.fromJson(Map<String, dynamic> json) =>
      _$ProductImageVoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (image ?? "");
  }
}