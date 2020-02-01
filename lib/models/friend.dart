import 'package:json_annotation/json_annotation.dart';
import 'package:rundown_flutter/models/user.dart';

part 'friend.g.dart';

@JsonSerializable()
class Friend {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "user")
  int userId;
  @JsonKey(name: "friend")
  User friend;
  @JsonKey(name: "is_blocked")
  bool isBlocked;
  @JsonKey(name: "is_accepted")
  bool isAccepted;

  Friend();

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}