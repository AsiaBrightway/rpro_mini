
import 'package:json_annotation/json_annotation.dart';

import '../../fcm/access_firebase_token.dart';
part 'slider_vo.g.dart';

@JsonSerializable()
class SliderVo{
  @JsonKey(name: 'slider_id')
  final int sliderId;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'created_at')
  final String createdAt;

  SliderVo(this.sliderId, this.image, this.createdAt);

  String getImageWithBaseUrl(){
    return kBaseImageUrl + (image ?? "");
  }

  factory SliderVo.fromJson(Map<String, dynamic> json) =>
      _$SliderVoFromJson(json);

  Map<String, dynamic> toJson() => _$SliderVoToJson(this);
}