import 'package:json_annotation/json_annotation.dart';
part 'product_image_request.g.dart';

@JsonSerializable()
class ProductImageRequest{
  @JsonKey(name: 'image')
  final String image;

  ProductImageRequest(this.image);

  factory ProductImageRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductImageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageRequestToJson(this);
}