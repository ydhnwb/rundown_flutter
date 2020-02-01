// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseListResponse _$BaseListResponseFromJson(Map<String, dynamic> json) {
  return BaseListResponse()
    ..message = json['message'] as String
    ..status = json['status'] as bool
    ..data = json['data'] as List;
}

Map<String, dynamic> _$BaseListResponseToJson(BaseListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'data': instance.data,
    };
