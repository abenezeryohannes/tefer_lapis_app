
import 'package:flutter/material.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/post.model.dart';
import 'package:domain/models/user.model.dart';

import './model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'moreinfo.model.dart';

part 'activity.model.g.dart';

@JsonSerializable()
class ActivityModel extends Model with ChangeNotifier{
  int? id;
  int? user_id;
  int? reference_id;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  MoreInfoModel? MoreInfo;
  FundraiserModel? Fundraiser;
  PostModel? Post;
  UserModel? User;

  UserModel getUser() { return User ?? UserModel.fresh();}
  FundraiserModel getFundraiser() { return Fundraiser ?? FundraiserModel.fresh();}
  PostModel getPost() { return Post ?? PostModel.fresh();}

  //MoreInfo? MoreInfo;
  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
  ActivityModel.fresh({user_id: 1, reference_id:1, type:'fundraiser'});

  ActivityModel(
      this.id,
      this.user_id,
      this.reference_id,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.MoreInfo,
      this.Fundraiser,
      this.Post,
      this.User);

  @override
  String toString() {
    return 'ActivityModel{id: $id, user_id: $user_id, reference_id: $reference_id, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, MoreInfo: $MoreInfo, Fundraiser: $Fundraiser, Post: $Post, User: $User}';
  }
}