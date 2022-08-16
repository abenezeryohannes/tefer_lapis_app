// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      data: json['data'],
      total_items: json['total_items'] as int?,
      total_pages: json['total_pages'] as int?,
      current_page: json['current_page'] as int?,
      limit: json['limit'] as int?,
      sort_by: json['sort_by'] as String?,
      sort: json['sort'] as String?,
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total_items': instance.total_items,
      'total_pages': instance.total_pages,
      'current_page': instance.current_page,
      'limit': instance.limit,
      'sort_by': instance.sort_by,
      'sort': instance.sort,
    };
