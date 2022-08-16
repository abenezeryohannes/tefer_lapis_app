
import 'package:flutter/material.dart';
import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token.model.g.dart';

@JsonSerializable()
class TokenModel extends Model with ChangeNotifier{
  int? id;
  int? user_id;
  String? token;
  String? device_token;
  String? type;
  DateTime? until;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  TokenModel.fresh({this.token = "token", this.type="donor"});


  TokenModel({this.user_id, this.device_token, this.token, this.type, this.until});

  @override
  String toString() {
    return 'Token{user_id: $user_id, token: $token, type: $type, until: $until}';
  }
}