// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonationModel _$DonationModelFromJson(Map<String, dynamic> json) =>
    DonationModel(
      id: json['id'] as int?,
      fundraiser_id: json['fundraiser_id'] as int?,
      donor_user_id: json['donor_user_id'] as int?,
      stationary_user_id: json['stationary_user_id'] as int?,
      payment_id: json['payment_id'] as int?,
      delivery_id: json['delivery_id'] as int?,
      payment_code: json['payment_code'] as String?,
      differed: json['differed'] as int?,
      amount: json['amount'] as String?,
      distance: json['distance'] as String?,
          status: json['status'] as String?,
      payement_date: json['payement_date'] == null
          ? null
          : DateTime.parse(json['payement_date'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      DonationItems: (json['DonationItems'] as List<dynamic>?)
          ?.map((e) => DonationItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      Donor: json['Donor'] == null
          ? null
          : UserModel.fromJson(json['Donor'] as Map<String, dynamic>),
      Stationary: json['Stationary'] == null
          ? null
          : UserModel.fromJson(json['Stationary'] as Map<String, dynamic>),
      School: json['School'] == null
          ? null
          : UserModel.fromJson(json['School'] as Map<String, dynamic>),
      Payment: json['Payment'] == null
          ? null
          : PaymentModel.fromJson(json['Payment'] as Map<String, dynamic>),
      Fundraiser: json['Fundraiser'] == null
          ? null
          : FundraiserModel.fromJson(
              json['Fundraiser'] as Map<String, dynamic>),
    )..Deliveries = (json['Deliveries'] as List<dynamic>?)
        ?.map((e) => DeliveryModel.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$DonationModelToJson(DonationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fundraiser_id': instance.fundraiser_id,
      'donor_user_id': instance.donor_user_id,
      'stationary_user_id': instance.stationary_user_id,
      'payment_id': instance.payment_id,
      'delivery_id': instance.delivery_id,
      'payment_code': instance.payment_code,
      'differed': instance.differed,
      'amount': instance.amount,
      'distance': instance.distance,
      'status': instance.status,
      'payement_date': instance.payement_date?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'DonationItems': instance.DonationItems,
      'Donor': instance.Donor,
      'Stationary': instance.Stationary,
      'School': instance.School,
      'Payment': instance.Payment,
      'Fundraiser': instance.Fundraiser,
      'Deliveries': instance.Deliveries,
    };
