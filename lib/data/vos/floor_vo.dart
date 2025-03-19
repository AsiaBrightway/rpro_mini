
import 'package:json_annotation/json_annotation.dart';
part 'floor_vo.g.dart';

@JsonSerializable()
class FloorVo{
  @JsonKey(name: 'floor_id')
  final int floorId;

  @JsonKey(name: 'floor_name')
  final String floorName;

  @JsonKey(name: 'other_name')
  final String? otherName;

  @JsonKey(name: 'floor_code')
  final String? floorCode;

  @JsonKey(name: 'is_discontinued')
  final int isDiscontinued;

  @JsonKey(name: 'is_deleted')
  final int isDeleted;

  @JsonKey(name: 'location_id')
  final int locationId;

  @JsonKey(name: 'is_updated')
  final int? isUpdated;

  @JsonKey(name: 'modified_by')
  final int? modifiedBy;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  FloorVo(
      this.floorId,
      this.floorName,
      this.otherName,
      this.floorCode,
      this.isDiscontinued,
      this.isDeleted,
      this.locationId,
      this.isUpdated,
      this.modifiedBy,
      this.createdAt,
      this.updatedAt);

  factory FloorVo.fromJson(Map<String,dynamic> json) => _$FloorVoFromJson(json);

  Map<String,dynamic> toJson() => _$FloorVoToJson(this);
}
