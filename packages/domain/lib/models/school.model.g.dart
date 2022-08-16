// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolModel _$SchoolModelFromJson(Map<String, dynamic> json) => SchoolModel(
      json['id'] as int?,
      json['students'] as int?,
      json['topic'] as String?,
      json['motto'] as String?,
      (json['minimum_distance'] as num?)?.toDouble(),
      json['scope'] as String?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SchoolModelToJson(SchoolModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'students': instance.students,
      'motto': instance.motto,
      'minimum_distance': instance.minimum_distance,
      'scope': instance.scope,
      'topic': instance.topic,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
