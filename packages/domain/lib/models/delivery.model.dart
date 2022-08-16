import 'package:domain/models/donation.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/user.model.dart';

import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery.model.g.dart';

@JsonSerializable()
class DeliveryModel extends Model{

  int? id;
  int? user_id;
  int? donation_id;
  String? status;
  String? distance;
  int? time;
  DateTime? trip_start_time;
  DateTime? trip_end_time;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? User;
  UserModel? School;
  UserModel? Donor;
  UserModel? Stationary;
  DonationModel? Donation;
  DateTime? expires_after;
  FundraiserModel? Fundraiser;

  UserModel getUser(){ return User ?? UserModel.fresh(); }
  FundraiserModel getFundraiser(){ return Fundraiser ?? FundraiserModel.fresh(); }
  DonationModel getDonation(){ return Donation ?? DonationModel.fresh(); }

  UserModel getDonor(){
    return Donor ?? UserModel.fresh();
  }

  UserModel getStationary(){
    return Stationary ?? UserModel.fresh();
  }

  UserModel getSchool(){
    return School ?? UserModel.fresh();
  }

  factory DeliveryModel.fromJson(Map<String, dynamic> json) => _$DeliveryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryModelToJson(this);

  DeliveryModel.fresh({id = -1, user_id = -1, donation_id = -1, status = "active", distance = "0"});

  DeliveryModel({this.user_id, this.donation_id, this.status, this.distance,
      this.time, this.trip_start_time, this.trip_end_time, this.Donor, this.Stationary,
      this.School, this.expires_after
  });
}