// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Search _$SearchFromJson(Map<String, dynamic> json) {
  return Search()
    ..users = json['users'] as List
    ..rundowns = json['rundowns'] as List;
}

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
      'users': instance.users,
      'rundowns': instance.rundowns,
    };
