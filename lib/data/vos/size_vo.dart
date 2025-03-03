import 'package:json_annotation/json_annotation.dart';

part 'size_vo.g.dart';

@JsonSerializable()
class SizeVo {
  @JsonKey(name: 'size_id')
  final int sizeId;

  @JsonKey(name: 'size_name')
  final String sizeName;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  SizeVo({
    required this.sizeId,
    required this.sizeName,
    required this.createdAt,
  });

  factory SizeVo.fromJson(Map<String, dynamic> json) => _$SizeVoFromJson(json);

  Map<String, dynamic> toJson() => _$SizeVoToJson(this);
}