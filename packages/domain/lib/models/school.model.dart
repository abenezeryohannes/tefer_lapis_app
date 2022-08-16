import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'school.model.g.dart';

@JsonSerializable()
class SchoolModel extends Model{
  int? id;
  int? students;
  String? motto;
  double? minimum_distance;
  String? scope;
  String? topic;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SchoolModel.fromJson(Map<String, dynamic> json) => _$SchoolModelFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolModelToJson(this);

  SchoolModel.fresh();

  SchoolModel(this.id, this.students, this.topic, this.motto, this.minimum_distance,
      this.scope, this.createdAt, this.updatedAt);
}