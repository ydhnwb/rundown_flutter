import 'package:json_annotation/json_annotation.dart';

part 'rundown_detail.g.dart';

@JsonSerializable()
class RundownDetail{
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "order_num")
  int orderNumber;
  @JsonKey(name: "with_date")
  String withDate;
  @JsonKey(name: "rundown")
  int rundownId;

  RundownDetail();

  factory RundownDetail.fromJson(Map<String, dynamic> json) => _$RundownDetailFromJson(json);
  Map<String, dynamic> toJson() => _$RundownDetailToJson(this);
}