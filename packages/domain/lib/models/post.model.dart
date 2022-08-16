import 'package:domain/models/user.model.dart';

import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.model.g.dart';

@JsonSerializable()
class PostModel extends Model{
  int? id;
  String? caption;
  String? image;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? User;

  UserModel getUser(){ return User?? UserModel.fresh();}

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostModel.fresh();

  PostModel({this.caption, this.image, this.type, this.User});
}