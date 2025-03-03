// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizeResponse _$SizeResponseFromJson(Map<String, dynamic> json) => SizeResponse(
      json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SizeVo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SizeResponseToJson(SizeResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
