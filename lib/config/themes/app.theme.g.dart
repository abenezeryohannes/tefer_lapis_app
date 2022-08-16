// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppTheme _$AppThemeFromJson(Map<String, dynamic> json) => AppTheme(
      selectedThemeData: AppThemeData.fromJson(
          json['selectedThemeData'] as Map<String, dynamic>),
      themeDatas: (json['themeDatas'] as List<dynamic>)
          .map((e) => AppThemeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppThemeToJson(AppTheme instance) => <String, dynamic>{
      'selectedThemeData': instance.selectedThemeData,
      'themeDatas': instance.themeDatas,
    };
