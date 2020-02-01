import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse{
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "status")
  bool status;
  @JsonKey(name: "data")
  Map<String, dynamic> data;

  BaseResponse();

  factory BaseResponse.fromJson(Map<String, dynamic> json) => _$BaseResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}