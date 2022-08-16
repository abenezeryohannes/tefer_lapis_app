// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moreinfo.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoreInfoModel _$MoreInfoModelFromJson(Map<String, dynamic> json) =>
    MoreInfoModel(
      json['id'] as int?,
      json['donated'] as String?,
      json['trips'] as String?,
      (json['minimum_distance'] as num?)?.toDouble(),
      json['topic'] as String?,
      json['delivery_topic'] as String?,
      json['motto'] as String?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    )
      ..distance_from_school = json['distance_from_school'] as String?
      ..total_donation_price = json['total_donation_price'] as String?
      ..nationality = json['nationality'] as String?
      ..scope = json['scope'] as String?
      ..age = json['age'] as int?
      ..students = json['students'] as int?;

Map<String, dynamic> _$MoreInfoModelToJson(MoreInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'minimum_distance': instance.minimum_distance,
      'motto': instance.motto,
      'topic': instance.topic,
      'delivery_topic': instance.delivery_topic,
      'distance_from_school': instance.distance_from_school,
      'total_donation_price': instance.total_donation_price,
      'nationality': instance.nationality,
      'donated': instance.donated,
      'trips': instance.trips,
      'scope': instance.scope,
      'age': instance.age,
      'students': instance.students,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
