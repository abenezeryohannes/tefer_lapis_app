// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation.item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonationItemModel _$DonationItemModelFromJson(Map<String, dynamic> json) =>
    DonationItemModel(
      donation_id: json['donation_id'] as int?,
      item_id: json['item_id'] as int?,
      unit_price: json['unit_price'] as String?,
      quantity: json['quantity'] as int?,
    )
      ..id = json['id'] as int?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String)
      ..Item = json['Item'] == null
          ? null
          : ItemModel.fromJson(json['Item'] as Map<String, dynamic>);

Map<String, dynamic> _$DonationItemModelToJson(DonationItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'donation_id': instance.donation_id,
      'item_id': instance.item_id,
      'unit_price': instance.unit_price,
      'quantity': instance.quantity,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'Item': instance.Item,
    };
