import 'package:domain/models/fundraiser.item.model.dart';
import 'package:domain/models/user.model.dart';

import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fundraiser.model.g.dart';

@JsonSerializable()
class FundraiserModel extends Model{
  int? id;
  int? user_id;
  String? title;
  String? description;
  String? image;
  String? status;
  int? items_count;
  int? donated_items_count;
  String? donated_amount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? average_price;

  List<FundraiserItemModel>? FundraiserItems;
  UserModel? User;


  UserModel getUser(){
    return User ?? UserModel.fresh();
  }

  UserModel getSchool(){
    return User ?? UserModel.fresh();
  }

  List<FundraiserItemModel> getFundraiserItems(){
    return FundraiserItems ?? [];
  }

  factory FundraiserModel.fromJson(Map<String, dynamic> json) => _$FundraiserModelFromJson(json);

  Map<String, dynamic> toJson() => _$FundraiserModelToJson(this);

  FundraiserModel.fresh({this.title="dummy title", this.description= "dummy_text",
    this.image= "public/placeholder.jpg",
    this.items_count = 100,
    this.donated_items_count = 50, this.donated_amount = "1000"});

  FundraiserModel({
      this.id,
      this.user_id,
      this.title,
      this.description,
      this.image,
      this.items_count,
      this.donated_items_count,
      this.donated_amount,
      this.createdAt,
      this.updatedAt,
      this.User,
      this.average_price,
      this.status,
      this.FundraiserItems });

  @override
  String toString() {
    return 'Fundraiser{id: $id, user_id: $user_id,average_price: $average_price, title: $title, description: $description, image: $image, items_count:'
        ' $items_count, donated_items_count: $donated_items_count, donated_amount: $donated_amount,'
        ' createdAt: $createdAt, updatedAt: $updatedAt, fundraiserItems: $FundraiserItems}';
  }
}