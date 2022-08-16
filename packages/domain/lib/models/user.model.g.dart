// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as int?,
      full_name: json['full_name'] as String?,
      phone_number: json['phone_number'] as String?,
      email_address: json['email_address'] as String?,
      user_type_id: json['user_type_id'] as int?,
      uuid: json['uuid'] as String?,
      type: json['type'] as String?,
      avatar: json['avatar'] as String?,
      theme: json['theme'] as String?,
      locale: json['locale'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      Location: json['Location'] == null
          ? null
          : LocationModel.fromJson(json['Location'] as Map<String, dynamic>),
      total_donation_price: json['total_donation_price'] as String?,
      distance_from_school: (json['distance_from_school'] as num?)?.toDouble(),
      Token: json['Token'] == null
          ? null
          : TokenModel.fromJson(json['Token'] as Map<String, dynamic>),
      MoreInfo: json['MoreInfo'] == null
          ? null
          : MoreInfoModel.fromJson(json['MoreInfo'] as Map<String, dynamic>),
      walkthrough: json['walkthrough'] as bool? ?? true,
      introduction: json['introduction'] as bool? ?? true,
      newUser: json['newUser'] as bool? ?? false,
      StationaryItems: (json['StationaryItems'] as List<dynamic>?)
              ?.map((e) =>
                  StationaryItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'full_name': instance.full_name,
      'phone_number': instance.phone_number,
      'email_address': instance.email_address,
      'user_type_id': instance.user_type_id,
      'uuid': instance.uuid,
      'avatar': instance.avatar,
      'type': instance.type,
      'theme': instance.theme,
      'locale': instance.locale,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'Location': instance.Location,
      'Token': instance.Token,
      'MoreInfo': instance.MoreInfo,
      'StationaryItems': instance.StationaryItems,
      'walkthrough': instance.walkthrough,
      'introduction': instance.introduction,
      'newUser': instance.newUser,
      'distance_from_school': instance.distance_from_school,
      'total_donation_price': instance.total_donation_price,
    };
