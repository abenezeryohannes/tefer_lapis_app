import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'donor.model.g.dart';

@JsonSerializable()
class DonorModel extends Model{
  int? id;
  String? nationality;
  String? donated;
  int? age;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DonorModel.fromJson(Map<String, dynamic> json) => _$DonorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DonorModelToJson(this);

  DonorModel.fresh();

  DonorModel(this.donated, this.nationality, this.age);
}