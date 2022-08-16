// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor.stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonorStat _$DonorStatFromJson(Map<String, dynamic> json) => DonorStat(
      gave_away: json['gave_away'] as int?,
      donated: json['donated'] as int?,
      delivered: json['delivered'] as int?,
    );

Map<String, dynamic> _$DonorStatToJson(DonorStat instance) => <String, dynamic>{
      'gave_away': instance.gave_away,
      'donated': instance.donated,
      'delivered': instance.delivered,
    };
