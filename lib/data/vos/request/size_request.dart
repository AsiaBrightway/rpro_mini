
import 'package:json_annotation/json_annotation.dart';

part 'size_request.g.dart';

@JsonSerializable()
class SizeRequest {
  @JsonKey(name: 'size')
  final String size;

  SizeRequest({required this.size});

  factory SizeRequest.fromJson(Map<String, dynamic> json) =>
      _$SizeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SizeRequestToJson(this);
}