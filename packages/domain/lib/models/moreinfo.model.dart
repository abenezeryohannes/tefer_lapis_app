import 'package:domain/models/user.model.dart';

import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moreinfo.model.g.dart';

@JsonSerializable()
class MoreInfoModel extends Model{
  int? id;
  double? minimum_distance;
  String? motto;
  String? topic;
  String? distance_from_school;
  String? total_donation_price;
  String? nationality;
  String? scope;
  String? donated;
  String? trips;
  String? delivery_topic;
  int? age;
  int? students;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory MoreInfoModel.fromJson(Map<String, dynamic> json) => _$MoreInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoreInfoModelToJson(this);

  @override
  String toString() {
    return 'MoreInfoModel{id: $id, minimum_distance: $minimum_distance, motto: $motto, distance_from_school: $distance_from_school, total_donation_price: $total_donation_price, nationality: $nationality, age: $age, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  MoreInfoModel.fresh({this.motto = "dummy_text",this.donated="0.00", this.minimum_distance = 201});

  MoreInfoModel(this.id, this.donated,this.trips, this.minimum_distance, this.topic, this.delivery_topic, this.motto, this.createdAt,
      this.updatedAt);

}