
import 'package:json_annotation/json_annotation.dart';
part 'item_vo.g.dart';

@JsonSerializable()
class ItemVo{
  @JsonKey(name: 'item_id')
  final int itemId;

  @JsonKey(name: 'main_category_id')
  final int mainCategoryId;

  @JsonKey(name: 'sub_category_id')
  final int subCategoryId;

  @JsonKey(name: 'item_type_id')
  final int itemTypeId;

  @JsonKey(name: 'item_code')
  final String? itemCode;

  @JsonKey(name: 'bar_code')
  final String? barCode;

  @JsonKey(name: 'item_name')
  final String? itemName;

  @JsonKey(name: 'other_name')
  final String? otherName;

  @JsonKey(name: 'item_image')
  final String? image;

  @JsonKey(name: 'item_selling_price')
  final String? price;

  @JsonKey(name: 'item_price')
  final String? itemPrice;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  ItemVo(
      this.itemId,
      this.mainCategoryId,
      this.subCategoryId,
      this.itemTypeId,
      this.itemCode,
      this.barCode,
      this.itemName,
      this.otherName,
      this.image,
      this.createdAt,
      this.updatedAt, this.price, this.itemPrice);

  factory ItemVo.fromJson(Map<String, dynamic> json) =>
      _$ItemVoFromJson(json);

  Map<String, dynamic> toJson() => _$ItemVoToJson(this);

}