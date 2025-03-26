import 'package:json_annotation/json_annotation.dart';

import '../../data/vos/user_vo.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'user')
  final UserVo user;

  LoginResponse(this.user, {
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}