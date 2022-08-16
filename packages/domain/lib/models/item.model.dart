import './model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.model.g.dart';

@JsonSerializable()
class ItemModel extends Model{
  int? id;
  String? name;
  String? description;
  String? avg_price;
  String? image;
  String? unit;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ItemModel.fromJson(Map<String, dynamic> json) => _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);

  ItemModel.fresh({this.image="public/icons/pencil.png",this.unit="pcs", this.name = 'pencil', this.avg_price = "10"});

  ItemModel({ this.name, this.description,this.unit, this.avg_price, this.image });

  @override
  String toString() {
    return 'Item{id: $id, name: $name, description: $description, avg_price: $avg_price, image: $image, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}