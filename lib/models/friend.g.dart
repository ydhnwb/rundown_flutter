// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend()
    ..id = json['id'] as int
    ..userId = json['user'] as int
    ..friend = json['friend'] as Map<String, dynamic>
    ..isBlocked = json['is_blocked'] as bool
    ..isAccepted = json['is_accepted'] as bool;
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.userId,
      'friend': instance.friend,
      'is_blocked': instance.isBlocked,
      'is_accepted': instance.isAccepted,
    };
