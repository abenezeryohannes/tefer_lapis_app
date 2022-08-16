// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wrapper _$WrapperFromJson(Map<String, dynamic> json) => Wrapper(
      data: json['data'],
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$WrapperToJson(Wrapper instance) => <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'success': instance.success,
    };
