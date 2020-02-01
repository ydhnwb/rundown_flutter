// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rundown_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RundownDetail _$RundownDetailFromJson(Map<String, dynamic> json) {
  return RundownDetail()
    ..id = json['id'] as int
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..orderNumber = json['order_num'] as int
    ..withDate = json['with_date'] as String
    ..rundownId = json['rundown'] as int;
}

Map<String, dynamic> _$RundownDetailToJson(RundownDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'order_num': instance.orderNumber,
      'with_date': instance.withDate,
      'rundown': instance.rundownId,
    };
