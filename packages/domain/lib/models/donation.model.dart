import 'package:domain/models/delivery.model.dart';
import 'package:domain/models/donation.item.model.dart';
import 'package:domain/models/fundraiser.model.dart';
import 'package:domain/models/model.dart';
import 'package:domain/models/payment.model.dart';
import 'package:domain/models/user.model.dart';

import 'package:json_annotation/json_annotation.dart';


part 'donation.model.g.dart';

@JsonSerializable()
class DonationModel extends Model{

  int? id;
  int? fundraiser_id;
  int? donor_user_id;
  int? stationary_user_id;
  int? payment_id;
  int? delivery_id;
  String? payment_code;
  int? differed;
  String? amount;
  String? status;
  String? distance;
  DateTime? payement_date;
  DateTime? createdAt;
  DateTime? updatedAt;

  List<DonationItemModel>? DonationItems;
  UserModel? Donor;
  UserModel? Stationary;
  UserModel? School;
  PaymentModel? Payment;
  FundraiserModel? Fundraiser;
  List<DeliveryModel>? Deliveries;

  List<DonationItemModel> getDonationItems(){
    DonationItems = DonationItems ?? [];
    return DonationItems!;
  }

  UserModel getDonor(){
    return Donor ?? UserModel.fresh();
  }

  List<DeliveryModel> getDeliveries(){
    return Deliveries ?? [];
  }

  UserModel getStationary(){
    return Stationary ?? UserModel.fresh();
  }
  UserModel getSchool(){
    return School ?? UserModel.fresh();
  }

  PaymentModel getPayment(){
    return Payment ?? PaymentModel.fresh();
  }

  FundraiserModel getFundraiser() {
    return Fundraiser ?? FundraiserModel.fresh();
  }



  DonationModel.fresh({ this.amount = "1000", this.distance = "100", this.payement_date= null, this.payment_code = "3904928", this.differed = 0 });

  factory DonationModel.fromJson(Map<String, dynamic> json) => _$DonationModelFromJson(json);

  Map<String, dynamic> toJson() => _$DonationModelToJson(this);


  @override
  String toString() {
    return 'DonationModel{id: $id, fundraiser_id: $fundraiser_id, donor_user_id: $donor_user_id, stationary_user_id: $stationary_user_id, payment_id: $payment_id, delivery_id: $delivery_id, payment_code: $payment_code, differed: $differed, amount: $amount, distance: $distance, payement_date: $payement_date, createdAt: $createdAt, updatedAt: $updatedAt, DonationItems: $DonationItems, Payment: $Payment, Delivery: $Deliveries}';
  }

  DonationModel({
      this.id,
      this.fundraiser_id,
      this.donor_user_id,
      this.stationary_user_id,
      this.payment_id,
      this.delivery_id,
      this.payment_code,
      this.differed,
      this.amount,
      this.distance,
      this.status,
      this.payement_date,
      this.createdAt,
      this.updatedAt,
      this.DonationItems,
      this.Donor,
      this.Stationary,
      this.School,
      this.Payment,
      this.Fundraiser
  });


}