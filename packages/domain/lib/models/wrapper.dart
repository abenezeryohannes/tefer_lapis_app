
import 'package:json_annotation/json_annotation.dart';

part 'wrapper.g.dart';

@JsonSerializable()
class Wrapper {

  dynamic data;

  String? message;

  bool? success = true;

  //MoreInfo? MoreInfo;

  factory Wrapper.fromJson(Map<String, dynamic> json) => _$WrapperFromJson(json);

  Map<String, dynamic> toJson() => _$WrapperToJson(this);

  Wrapper.fresh({this.success, this.message, this.data});

  Wrapper({this.data, this.message, required this.success});

  @override
  String toString() {
    return 'Wrapper{message: $message, success: $success, data: $data, }';
  }
}