
import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';
part 'category_vo.g.dart';

@JsonSerializable()
class CategoryVo {
  @JsonKey(name: 'category_id')
  final int categoryId;

  @JsonKey(name: 'category_name')
  final String categoryName;

  @JsonKey(name: 'image')
  final String? image; // Nullable field

  @JsonKey(name: 'created_at')
  final String? createdAt;

  CategoryVo({
    required this.categoryId,
    required this.categoryName,
    this.image,
    required this.createdAt,
  });

  factory CategoryVo.fromJson(Map<String, dynamic> json) =>
      _$CategoryVoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryVoToJson(this);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (image ?? "");
  }
}