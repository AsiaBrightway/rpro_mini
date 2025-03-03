// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorVo _$ColorVoFromJson(Map<String, dynamic> json) => ColorVo(
      (json['color_id'] as num).toInt(),
      json['color_name'] as String,
      json['color_code'] as String,
      json['created_at'] as String?,
    );

Map<String, dynamic> _$ColorVoToJson(ColorVo instance) => <String, dynamic>{
      'color_id': instance.colorId,
      'color_name': instance.colorName,
      'color_code': instance.colorCode,
      'created_at': instance.createdAt,
    };
