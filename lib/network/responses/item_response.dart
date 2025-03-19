
import 'package:json_annotation/json_annotation.dart';
import '../../data/vos/item_vo.dart';
part 'item_response.g.dart';

@JsonSerializable()
class ItemResponse{
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<ItemVo>? data;

  ItemResponse(this.message, this.data);

  factory ItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemResponseToJson(this);
}