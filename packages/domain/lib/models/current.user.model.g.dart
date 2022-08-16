// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current.user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUserModel _$CurrentUserModelFromJson(Map<String, dynamic> json) =>
    CurrentUserModel(
      User: json['User'] == null
          ? null
          : UserModel.fromJson(json['User'] as Map<String, dynamic>),
      walkthrough: json['walkthrough'] as bool?,
      introduction: json['introduction'] as bool?,
    );

Map<String, dynamic> _$CurrentUserModelToJson(CurrentUserModel instance) =>
    <String, dynamic>{
      'User': instance.User,
      'walkthrough': instance.walkthrough,
      'introduction': instance.introduction,
    };
