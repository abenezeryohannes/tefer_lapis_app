
import 'package:json_annotation/json_annotation.dart';

part 'donor.stat.g.dart';

@JsonSerializable()
class DonorStat {

  int? gave_away;
  int? donated;
  int? delivered;


  factory DonorStat.fromJson(Map<String, dynamic> json) => _$DonorStatFromJson(json);

  Map<String, dynamic> toJson() => _$DonorStatToJson(this);

  DonorStat.fresh({this.gave_away, this.donated, this.delivered});

  DonorStat({ this.gave_away, required this.donated, required this.delivered});

  @override
  String toString() {
    return 'DonorStat{  gave_away: $gave_away, '
        'donated: $donated, delivered: $delivered}';
  }
}