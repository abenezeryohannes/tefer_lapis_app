import './model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'item.model.dart';

part 'fundraiser.item.model.g.dart';

@JsonSerializable()
class FundraiserItemModel extends Model{
  int? id;
  int? fundraiser_id;
  int? item_id;
  int? quantity;
  int? donated;
  DateTime? createdAt;
  DateTime? updatedAt;
  ItemModel? Item;

  ItemModel getItem() {return Item ?? ItemModel.fresh();}

  factory FundraiserItemModel.fromJson(Map<String, dynamic> json) => _$FundraiserItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FundraiserItemModelToJson(this);

  FundraiserItemModel.fresh({this.quantity=10, this.donated = 10});

  FundraiserItemModel({this.id, this.fundraiser_id, this.item_id, this.quantity,
      this.createdAt, this.updatedAt, this.Item, this.donated});

  @override
  String toString() {
    return 'FundraiserItem{id: $id, fundraiser_id: $fundraiser_id, item_id: $item_id, quantity: $quantity,'
        ' donated $donated, item: $Item}';
  }

}