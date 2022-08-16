// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      transaction_id: json['transaction_id'] as String?,
      status: json['status'] as String?,
      transfered_account: json['transfered_account'] as String?,
      payment_method: json['payment_method'] as String?,
      amount: json['amount'] as String?,
    )
      ..id = json['id'] as int?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_id': instance.transaction_id,
      'status': instance.status,
      'transfered_account': instance.transfered_account,
      'payment_method': instance.payment_method,
      'amount': instance.amount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
