// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminVo _$AdminVoFromJson(Map<String, dynamic> json) => AdminVo(
      adminId: (json['admin_id'] as num).toInt(),
      userName: json['user_name'] as String,
      storeId: (json['store_id'] as num).toInt(),
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$AdminVoToJson(AdminVo instance) => <String, dynamic>{
      'admin_id': instance.adminId,
      'user_name': instance.userName,
      'store_id': instance.storeId,
      'is_active': instance.isActive,
    };
