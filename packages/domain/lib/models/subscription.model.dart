import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription.model.g.dart';

@JsonSerializable()
class SubscriptionModel extends Model{
  int? id;
  int? subscriber_id;
  int? school_id;
  String? status;
  String? as;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  SubscriptionModel.fresh();

  SubscriptionModel({this.subscriber_id, this.school_id, this.status, this.as});
}