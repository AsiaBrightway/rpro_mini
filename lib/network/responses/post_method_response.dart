
import 'package:json_annotation/json_annotation.dart';
part 'post_method_response.g.dart';

@JsonSerializable()
class PostMethodResponse{
  @JsonKey(name: 'message')
  final String? message;

  PostMethodResponse(this.message);

  factory PostMethodResponse.fromJson(Map<String,dynamic> json) => _$PostMethodResponseFromJson(json);

  Map<String,dynamic> toJson() => _$PostMethodResponseToJson(this);
}