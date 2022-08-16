// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverStat _$DriverStatFromJson(Map<String, dynamic> json) => DriverStat(
      trips: json['trips'] as int?,
      delivered_items: json['delivered_items'] as int?,
      traveled: json['traveled'] as int?,
    );

Map<String, dynamic> _$DriverStatToJson(DriverStat instance) =>
    <String, dynamic>{
      'trips': instance.trips,
      'delivered_items': instance.delivered_items,
      'traveled': instance.traveled,
    };
