// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorResponse _$ColorResponseFromJson(Map<String, dynamic> json) =>
    ColorResponse(
      json['message'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => ColorVo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ColorResponseToJson(ColorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
