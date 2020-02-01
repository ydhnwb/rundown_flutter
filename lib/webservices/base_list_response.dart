import 'package:json_annotation/json_annotation.dart';

part 'base_list_response.g.dart';

@JsonSerializable()
class BaseListResponse{
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "status")
  bool status;
  @JsonKey(name: "data")
  List<dynamic> data;

  BaseListResponse();

  factory BaseListResponse.fromJson(Map<String, dynamic> json) => _$BaseListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaseListResponseToJson(this);
}