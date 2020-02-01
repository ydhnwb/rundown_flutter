import 'package:json_annotation/json_annotation.dart';

part 'rundown.g.dart';

@JsonSerializable()
class Rundown {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "is_trashed")
  bool isTrashed;
  @JsonKey(name: "created_on")
  String createdOn;
  @JsonKey(name: "updated_on")
  String updatedOn;
  @JsonKey(name: "user_profile")
  int userId;
  @JsonKey(name: "rundown_details")
  List<dynamic> rundownDetails;

  Rundown();

  factory Rundown.fromJson(Map<String, dynamic> json) => _$RundownFromJson(json);
  Map<String, dynamic> toJson() => _$RundownToJson(this);
}