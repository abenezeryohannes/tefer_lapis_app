
import 'package:json_annotation/json_annotation.dart';

part 'driver.stat.g.dart';

@JsonSerializable()
class DriverStat {


  int? trips;
  int? delivered_items;
  int? traveled;


  factory DriverStat.fromJson(Map<String, dynamic> json) => _$DriverStatFromJson(json);

  Map<String, dynamic> toJson() => _$DriverStatToJson(this);

  DriverStat.fresh({ this.trips, this.delivered_items, this.traveled });

  DriverStat({ this.trips, required this.delivered_items, required this.traveled });

  @override
  String toString() {
    return 'DriverStat{ trips: $trips, delivered_items: $delivered_items, '
        'traveled: $traveled}';
  }
}