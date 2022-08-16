import 'package:domain/models/stationary.item.model.dart';
import 'package:flutter/material.dart';
import './model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'location.model.dart';
import 'moreinfo.model.dart';
import 'token.model.dart';

part 'user.model.g.dart';

@JsonSerializable()
class UserModel extends Model with ChangeNotifier{
  int? id;
  String? full_name;
  String? phone_number;
  String? email_address;
  int? user_type_id;
  String? uuid;
  String? avatar;
  String? type;
  String? theme;
  String? locale;
  DateTime? createdAt;
  DateTime? updatedAt;

  LocationModel? Location;
  // StationaryModel? Stationary;
  // SchoolModel? School;
  // DonorModel? Donor;
  TokenModel? Token;
  MoreInfoModel? MoreInfo;
  List<StationaryItemModel>? StationaryItems;

  bool? walkthrough;
  bool? introduction;
  bool? newUser;

  //for stationaries only
  double? distance_from_school;
  String? total_donation_price;

  LocationModel getLocation() { return Location ?? LocationModel.fresh();}
  TokenModel getToken() { return Token ?? TokenModel.fresh();}

  MoreInfoModel getDonor() { return MoreInfo ?? MoreInfoModel.fresh();}
  MoreInfoModel getSchool() { return MoreInfo ?? MoreInfoModel.fresh();}
  MoreInfoModel getStationary() { return MoreInfo ?? MoreInfoModel.fresh();}
  List<StationaryItemModel> getStationaryItems() { return StationaryItems ?? [ ];}

  //MoreInfo? MoreInfo;
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel.fresh({
    this.full_name = "full_name", this.avatar="placeholder.jpg",
    this.theme = "pelete 1", this.locale = "en-US",
    this.walkthrough=true, this.introduction=true,
    this.newUser=true
  });

  UserModel({
      this.id,
      this.full_name,
      this.phone_number,
      this.email_address,
      this.user_type_id,
      this.uuid,
      this.type,
      this.avatar,
      this.theme,
      this.locale,
      this.createdAt,
      this.updatedAt,
      this.Location,
      this.total_donation_price,
      this.distance_from_school,
      this.Token,
      this.MoreInfo,
      this.walkthrough = true,
      this.introduction = true,
      this.newUser = false,
      this.StationaryItems = const []
  });

  @override
  String toString() {
    return 'UserModel{id: $id, full_name: $full_name, phone_number: $phone_number, email_address:'
        ' $email_address, user_type_id: $user_type_id, uuid: $uuid, avatar: $avatar, type: $type, '
        '  createdAt: $createdAt, updatedAt: $updatedAt, Location: $Location, Token: $Token, MoreInfo: '
        '$MoreInfo, walkthrough: $walkthrough, introduction: $introduction, newUser: $newUser}';
  }

  void copy(UserModel? userModel) {
    if(userModel!=null){
      this.id = userModel.id;
      this.full_name = userModel.full_name;
      this.phone_number = userModel.phone_number;
      this.email_address = userModel.email_address;
      this.user_type_id = userModel.user_type_id;
      this.uuid = userModel.uuid;
      this.avatar = userModel.avatar;
      this.type = userModel.type;
      this.Location = userModel.Location;
      this.Token = userModel.Token;
      this.MoreInfo = userModel.MoreInfo;
      this.newUser = userModel.newUser;
      this.introduction = userModel.introduction;
      this.walkthrough = userModel.walkthrough;
      this.createdAt = userModel.createdAt;
      this.updatedAt = userModel.updatedAt;
      this.Token = userModel.Token;
      this.MoreInfo = userModel.MoreInfo;
      this.Location = userModel.Location;
    }
    print(this.toString());
  }

  String getTheme() { return theme ?? 'palette1';}


}