import 'package:json_annotation/json_annotation.dart';

part 'admin_vo.g.dart';

@JsonSerializable()
class AdminVo {
  @JsonKey(name: 'admin_id')
  final int adminId;

  @JsonKey(name: 'user_name')
  final String userName;

  @JsonKey(name: 'store_id')
  final int storeId;

  @JsonKey(name: 'is_active')
  final bool isActive;

  AdminVo({
    required this.adminId,
    required this.userName,
    required this.storeId,
    required this.isActive,
  });

  factory AdminVo.fromJson(Map<String, dynamic> json) => _$AdminVoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminVoToJson(this);
}