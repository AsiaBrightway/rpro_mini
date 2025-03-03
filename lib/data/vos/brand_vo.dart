import 'package:json_annotation/json_annotation.dart';
import 'package:rpro_mini/fcm/access_firebase_token.dart';

import '../../fcm/access_firebase_token.dart';

part 'brand_vo.g.dart';

@JsonSerializable()
class BrandVo {
  @JsonKey(name: 'brand_id')
  final int brandId;

  @JsonKey(name: 'brand_name')
  final String brandName;

  @JsonKey(name: 'brand_description')
  final String brandDescription;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  BrandVo({
    required this.brandId,
    required this.brandName,
    required this.brandDescription,
    required this.image,
    required this.createdAt,
  });

  factory BrandVo.fromJson(Map<String, dynamic> json) => _$BrandVoFromJson(json);

  Map<String, dynamic> toJson() => _$BrandVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (image ?? "");
  }
}