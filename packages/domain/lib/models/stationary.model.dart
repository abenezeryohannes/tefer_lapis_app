import 'package:domain/models/user.model.dart';

import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stationary.model.g.dart';

@JsonSerializable()
class StationaryModel extends Model{
  int? id;
  double? minimum_distance;
  String? motto;
  String? distance_from_school;
  String? total_donation_price;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory StationaryModel.fromJson(Map<String, dynamic> json) => _$StationaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationaryModelToJson(this);

  StationaryModel.fresh({this.motto = "dummy_text", this.minimum_distance = 200});

  StationaryModel(this.id, this.minimum_distance, this.motto, this.createdAt,
      this.updatedAt);


}