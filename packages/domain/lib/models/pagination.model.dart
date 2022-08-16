
import 'package:json_annotation/json_annotation.dart';

part 'pagination.model.g.dart';
@JsonSerializable()
class PaginationModel {

  dynamic data;
  int? total_items;
  int? total_pages;
  int? current_page;
  int? limit;
  String? sort_by;
  String? sort;
  //MoreInfo? MoreInfo;

  factory PaginationModel.fromJson(Map<String, dynamic> json) => _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  PaginationModel.fresh({this.data = null, this.total_items= 0, this.total_pages = 0, this.limit = 25, this.current_page = 1});

  PaginationModel({this.data, this.total_items, this.total_pages, this.current_page,
      this.limit, this.sort_by, this.sort});

  @override
  String toString() {
    return 'Pagination{ total_items: $total_items, total_pages: $total_pages, current_page: $current_page, limit: $limit, sort_by: $sort_by, sort: $sort, data: ${data.length},}';
  }
}