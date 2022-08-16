// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.theme.data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppThemeData _$AppThemeDataFromJson(Map<String, dynamic> json) => AppThemeData(
      BackgroundColors: (json['BackgroundColors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['0xFF282725', '0xFF282725'],
      name: json['name'] as String? ?? 'palette 1',
      AccentColor: json['AccentColor'] as String? ?? '0xFFFDD835',
      PrimaryColor: json['PrimaryColor'] as String? ?? '0xFFFDD835',
      PrimaryColorDark: json['PrimaryColorDark'] as String? ?? '0xFFFDD835',
      AccentColorLight: json['AccentColorLight'] as String? ?? '0xFFFFEB3B',
      AccentColorDark: json['AccentColorDark'] as String? ?? '0xFFFFEB3B',
      ActiveColor: json['ActiveColor'] as String? ?? '0xFFFFEB3B',
      highlightColor: json['highlightColor'] as String? ?? '0xFFFFF59D',
      InActiveColor: json['InActiveColor'] as String? ?? '0xFF33322F',
      UnSelectedColor: json['UnSelectedColor'] as String? ?? '0xFF9E9E9E',
      SelectedColor: json['SelectedColor'] as String? ?? '0xFFFDD835',
      TextColor: json['TextColor'] as String? ?? '0xFFFFFFFF',
      ButtonTextColor: json['ButtonTextColor'] as String? ?? '0xFF333333',
      OnBackground: json['OnBackground'] as String? ?? '0xFFFFFFFF',
    );

Map<String, dynamic> _$AppThemeDataToJson(AppThemeData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'BackgroundColors': instance.BackgroundColors,
      'AccentColor': instance.AccentColor,
      'PrimaryColor': instance.PrimaryColor,
      'PrimaryColorDark': instance.PrimaryColorDark,
      'AccentColorLight': instance.AccentColorLight,
      'AccentColorDark': instance.AccentColorDark,
      'ActiveColor': instance.ActiveColor,
      'InActiveColor': instance.InActiveColor,
      'highlightColor': instance.highlightColor,
      'UnSelectedColor': instance.UnSelectedColor,
      'SelectedColor': instance.SelectedColor,
      'TextColor': instance.TextColor,
      'ButtonTextColor': instance.ButtonTextColor,
      'OnBackground': instance.OnBackground,
    };
