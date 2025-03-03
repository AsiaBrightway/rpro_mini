// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizeVo _$SizeVoFromJson(Map<String, dynamic> json) => SizeVo(
      sizeId: (json['size_id'] as num).toInt(),
      sizeName: json['size_name'] as String,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$SizeVoToJson(SizeVo instance) => <String, dynamic>{
      'size_id': instance.sizeId,
      'size_name': instance.sizeName,
      'created_at': instance.createdAt,
    };
