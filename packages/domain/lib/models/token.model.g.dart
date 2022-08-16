// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => TokenModel(
      user_id: json['user_id'] as int?,
      device_token: json['device_token'] as String?,
      token: json['token'] as String?,
      type: json['type'] as String?,
      until: json['until'] == null
          ? null
          : DateTime.parse(json['until'] as String),
    )
      ..id = json['id'] as int?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'token': instance.token,
      'device_token': instance.device_token,
      'type': instance.type,
      'until': instance.until?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
