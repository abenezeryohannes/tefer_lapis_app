// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stationary.item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationaryItemModel _$StationaryItemModelFromJson(Map<String, dynamic> json) =>
    StationaryItemModel(
      stationary_id: json['stationary_id'] as int?,
      item_id: json['item_id'] as int?,
      quantity: json['quantity'] as int?,
      unit_price: json['unit_price'] as String?,
      status: json['status'] as String?,
      Item: json['Item'] == null
          ? null
          : ItemModel.fromJson(json['Item'] as Map<String, dynamic>),
      donatable_amount: json['donatable_amount'] as int?,
      donate: json['donate'] as int? ?? 0,
    )
      ..id = json['id'] as int?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$StationaryItemModelToJson(
        StationaryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stationary_id': instance.stationary_id,
      'item_id': instance.item_id,
      'unit_price': instance.unit_price,
      'quantity': instance.quantity,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'Item': instance.Item,
      'donatable_amount': instance.donatable_amount,
      'donate': instance.donate,
    };
