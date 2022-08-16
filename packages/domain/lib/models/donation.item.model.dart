import './model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'item.model.dart';

part 'donation.item.model.g.dart';

@JsonSerializable()
class DonationItemModel extends Model{

  int? id;
  int? donation_id;
  int? item_id;
  String? unit_price;
  int? quantity;
  DateTime? createdAt;
  DateTime? updatedAt;
  ItemModel? Item;

  factory DonationItemModel.fromJson(Map<String, dynamic> json) => _$DonationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$DonationItemModelToJson(this);

  ItemModel getItem() {return Item ?? ItemModel.fresh();}

  DonationItemModel.fresh();

  @override
  String toString() {
    return 'DonationItemModel{id: $id, donation_id: $donation_id, item_id: $item_id, unit_price: '
        '$unit_price, quantity: $quantity, Item: $Item}';
  }

  DonationItemModel({this.donation_id, this.item_id, this.unit_price, this.quantity});
}