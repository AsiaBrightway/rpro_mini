// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategoryResponse _$SubCategoryResponseFromJson(Map<String, dynamic> json) =>
    SubCategoryResponse(
      json['message'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => SubCategoryVo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubCategoryResponseToJson(
        SubCategoryResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
