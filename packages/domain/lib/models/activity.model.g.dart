// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      json['id'] as int?,
      json['user_id'] as int?,
      json['reference_id'] as int?,
      json['type'] as String?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      json['MoreInfo'] == null
          ? null
          : MoreInfoModel.fromJson(json['MoreInfo'] as Map<String, dynamic>),
      json['Fundraiser'] == null
          ? null
          : FundraiserModel.fromJson(
              json['Fundraiser'] as Map<String, dynamic>),
      json['Post'] == null
          ? null
          : PostModel.fromJson(json['Post'] as Map<String, dynamic>),
      json['User'] == null
          ? null
          : UserModel.fromJson(json['User'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'reference_id': instance.reference_id,
      'type': instance.type,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'MoreInfo': instance.MoreInfo,
      'Fundraiser': instance.Fundraiser,
      'Post': instance.Post,
      'User': instance.User,
    };
