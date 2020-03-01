// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend()
    ..id = json['id'] as int
    ..user = json['user'] as Map<String, dynamic>
    ..friend = json['friend'] as Map<String, dynamic>
    ..isBlocked = json['is_blocked'] as bool
    ..isAccepted = json['is_accepted'] as bool
    ..requestedBy = json['requested_by'] as int;
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'friend': instance.friend,
      'is_blocked': instance.isBlocked,
      'is_accepted': instance.isAccepted,
      'requested_by': instance.requestedBy,
    };
