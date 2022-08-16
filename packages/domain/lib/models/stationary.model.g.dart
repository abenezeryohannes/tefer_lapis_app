// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stationary.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationaryModel _$StationaryModelFromJson(Map<String, dynamic> json) =>
    StationaryModel(
      json['id'] as int?,
      (json['minimum_distance'] as num?)?.toDouble(),
      json['motto'] as String?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    )
      ..distance_from_school = json['distance_from_school'] as String?
      ..total_donation_price = json['total_donation_price'] as String?;

Map<String, dynamic> _$StationaryModelToJson(StationaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'minimum_distance': instance.minimum_distance,
      'motto': instance.motto,
      'distance_from_school': instance.distance_from_school,
      'total_donation_price': instance.total_donation_price,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
