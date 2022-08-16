// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      subscriber_id: json['subscriber_id'] as int?,
      school_id: json['school_id'] as int?,
      status: json['status'] as String?,
      as: json['as'] as String?,
    )
      ..id = json['id'] as int?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subscriber_id': instance.subscriber_id,
      'school_id': instance.school_id,
      'status': instance.status,
      'as': instance.as,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
