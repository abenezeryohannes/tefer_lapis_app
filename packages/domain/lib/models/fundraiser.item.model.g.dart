// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraiser.item.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FundraiserItemModel _$FundraiserItemModelFromJson(Map<String, dynamic> json) =>
    FundraiserItemModel(
      id: json['id'] as int?,
      fundraiser_id: json['fundraiser_id'] as int?,
      item_id: json['item_id'] as int?,
      quantity: json['quantity'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      Item: json['Item'] == null
          ? null
          : ItemModel.fromJson(json['Item'] as Map<String, dynamic>),
      donated: json['donated'] as int?,
    );

Map<String, dynamic> _$FundraiserItemModelToJson(
        FundraiserItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fundraiser_id': instance.fundraiser_id,
      'item_id': instance.item_id,
      'quantity': instance.quantity,
      'donated': instance.donated,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'Item': instance.Item,
    };
