import 'package:json_annotation/json_annotation.dart';

import './model.dart';

part 'location.model.g.dart';

@JsonSerializable()
class LocationModel extends Model{
  int? id;
  String? address;
  double? latitude;
  double? longitude;
  String? region;
  String? city;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  LocationModel.fresh({this.address = "Ethiopia, Addis Abeba", this.latitude = 0, this.longitude = 0});


  @override
  String toString() {
    return 'LocationModel{id: $id, address: $address, latitude: $latitude, longitude: $longitude, region: $region, city: $city, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  LocationModel({this.address, this.latitude, this.longitude, this.region, this.city});
}