
import 'package:json_annotation/json_annotation.dart';
part 'user_vo.g.dart';

@JsonSerializable()
class UserVo{
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'username')
  final String? userName;

  @JsonKey(name: 'user_role_id')
  final int userRoleId;

  @JsonKey(name: 'employee_id')
  final int employeeId;

  UserVo(this.id, this.name, this.userRoleId, this.employeeId, this.userName);

  factory UserVo.fromJson(Map<String, dynamic> json) => _$UserVoFromJson(json);

  Map<String, dynamic> toJson() => _$UserVoToJson(this);
}