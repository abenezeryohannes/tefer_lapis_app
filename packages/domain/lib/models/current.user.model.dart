
import 'package:flutter/material.dart';
import 'package:domain/models/user.model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'current.user.model.g.dart';


@JsonSerializable()
class CurrentUserModel with ChangeNotifier{

  UserModel? User;
  bool? walkthrough;
  bool? introduction;


  bool isIntroduction(){
    return introduction??((User!=null)?User!.introduction??false:false);
  }


  bool isWalkthrough(){
    return walkthrough??((User!=null)?User!.walkthrough??false:false);
  }


  factory CurrentUserModel.fromJson(Map<String, dynamic> json) => _$CurrentUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserModelToJson(this);

  // CurrentUserModel(this.User, this.walkthrough, this.introduction);
  CurrentUserModel({this.User, this.walkthrough, this.introduction});

  CurrentUserModel.fresh({userModel});

  UserModel getUser() { return User ?? UserModel.fresh(); }

  void setUser(UserModel userModel) {
    User = userModel;
    notifyListeners();
  }

}