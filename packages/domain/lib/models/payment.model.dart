import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.model.g.dart';

@JsonSerializable()
class PaymentModel extends Model{
  int? id;
  String? transaction_id;
  String? status;
  String? transfered_account;
  String? payment_method;
  String? amount;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  PaymentModel.fresh();

  PaymentModel({this.transaction_id, this.status, this.transfered_account,
      this.payment_method, this.amount});
}