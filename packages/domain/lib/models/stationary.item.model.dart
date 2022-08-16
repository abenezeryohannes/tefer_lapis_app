import 'package:domain/models/item.model.dart';
import './model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'stationary.item.model.g.dart';

@JsonSerializable()
class StationaryItemModel extends Model{
  int? id;
  int? stationary_id;
  int? item_id;
  String? unit_price;
  int? quantity;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  ItemModel? Item;
  int? donatable_amount;
  int? donate = 0;

  ItemModel getItem() { return Item ?? ItemModel.fresh(); }

  factory StationaryItemModel.fromJson(Map<String, dynamic> json) => _$StationaryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationaryItemModelToJson(this);

  StationaryItemModel.fresh({this.donate = 0});

  StationaryItemModel({this.stationary_id, this.item_id, this.quantity, this.unit_price,
    this.status, this.Item, this.donatable_amount, this.donate = 0});

  @override
  String toString() {
    return 'StationaryItemModel{id: $id, stationary_id: $stationary_id, item_id: $item_id, unit_price: $unit_price, quantity: $quantity, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, Item: $Item, donatable_amount: $donatable_amount, donate: $donate}';
  }
}