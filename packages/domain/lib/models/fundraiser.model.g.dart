// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraiser.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FundraiserModel _$FundraiserModelFromJson(Map<String, dynamic> json) =>
    FundraiserModel(
      id: json['id'] as int?,
      user_id: json['user_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      items_count: json['items_count'] as int?,
      donated_items_count: json['donated_items_count'] as int?,
      donated_amount: json['donated_amount'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      User: json['User'] == null
          ? null
          : UserModel.fromJson(json['User'] as Map<String, dynamic>),
      average_price: json['average_price'] as String?,
      status: json['status'] as String?,
      FundraiserItems: (json['FundraiserItems'] as List<dynamic>?)
          ?.map((e) => FundraiserItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FundraiserModelToJson(FundraiserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'items_count': instance.items_count,
      'donated_items_count': instance.donated_items_count,
      'donated_amount': instance.donated_amount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'average_price': instance.average_price,
      'status': instance.status,
      'FundraiserItems': instance.FundraiserItems,
      'User': instance.User,
    };
