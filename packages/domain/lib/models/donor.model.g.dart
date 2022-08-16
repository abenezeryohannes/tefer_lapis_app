// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonorModel _$DonorModelFromJson(Map<String, dynamic> json) => DonorModel(
      json['donated'] as String?,
      json['nationality'] as String?,
      json['age'] as int?,
    )
      ..id = json['id'] as int?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$DonorModelToJson(DonorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'donated': instance.donated,
      'nationality': instance.nationality,
      'age': instance.age,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
