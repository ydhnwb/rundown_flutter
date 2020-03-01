import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

@JsonSerializable()
class Friend {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "user")
  Map<String, dynamic> user;
  @JsonKey(name: "friend")
  Map<String, dynamic> friend;
  @JsonKey(name: "is_blocked")
  bool isBlocked;
  @JsonKey(name: "is_accepted")
  bool isAccepted;
  @JsonKey(name: "requested_by")
  int requestedBy;

  Friend();

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}