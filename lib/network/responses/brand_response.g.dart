// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandResponse _$BrandResponseFromJson(Map<String, dynamic> json) =>
    BrandResponse(
      json['message'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => BrandVo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BrandResponseToJson(BrandResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
