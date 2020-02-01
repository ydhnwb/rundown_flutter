// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rundown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rundown _$RundownFromJson(Map<String, dynamic> json) {
  return Rundown()
    ..id = json['id'] as int
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..isTrashed = json['is_trashed'] as bool
    ..createdOn = json['created_on'] as String
    ..updatedOn = json['updated_on'] as String
    ..userId = json['user_profile'] as int
    ..rundownDetails = json['rundown_details'] as List;
}

Map<String, dynamic> _$RundownToJson(Rundown instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'is_trashed': instance.isTrashed,
      'created_on': instance.createdOn,
      'updated_on': instance.updatedOn,
      'user_profile': instance.userId,
      'rundown_details': instance.rundownDetails,
    };
