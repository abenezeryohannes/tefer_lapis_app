// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryModel _$DeliveryModelFromJson(Map<String, dynamic> json) =>
    DeliveryModel(
      user_id: json['user_id'] as int?,
      donation_id: json['donation_id'] as int?,
      status: json['status'] as String?,
      distance: json['distance'] as String?,
      time: json['time'] as int?,
      trip_start_time: json['trip_start_time'] == null
          ? null
          : DateTime.parse(json['trip_start_time'] as String),
      trip_end_time: json['trip_end_time'] == null
          ? null
          : DateTime.parse(json['trip_end_time'] as String),
      Donor: json['Donor'] == null
          ? null
          : UserModel.fromJson(json['Donor'] as Map<String, dynamic>),
      Stationary: json['Stationary'] == null
          ? null
          : UserModel.fromJson(json['Stationary'] as Map<String, dynamic>),
      School: json['School'] == null
          ? null
          : UserModel.fromJson(json['School'] as Map<String, dynamic>),
      expires_after: json['expires_after'] == null
          ? null
          : DateTime.parse(json['expires_after'] as String),
    )
      ..id = json['id'] as int?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String)
      ..User = json['User'] == null
          ? null
          : UserModel.fromJson(json['User'] as Map<String, dynamic>)
      ..Donation = json['Donation'] == null
          ? null
          : DonationModel.fromJson(json['Donation'] as Map<String, dynamic>)
      ..Fundraiser = json['Fundraiser'] == null
          ? null
          : FundraiserModel.fromJson(
              json['Fundraiser'] as Map<String, dynamic>);

Map<String, dynamic> _$DeliveryModelToJson(DeliveryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'donation_id': instance.donation_id,
      'status': instance.status,
      'distance': instance.distance,
      'time': instance.time,
      'trip_start_time': instance.trip_start_time?.toIso8601String(),
      'trip_end_time': instance.trip_end_time?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'User': instance.User,
      'School': instance.School,
      'Donor': instance.Donor,
      'Stationary': instance.Stationary,
      'Donation': instance.Donation,
      'expires_after': instance.expires_after?.toIso8601String(),
      'Fundraiser': instance.Fundraiser,
    };
