// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'additional_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdditionalModel _$AdditionalModelFromJson(Map<String, dynamic> json) =>
    _AdditionalModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$AdditionalModelToJson(_AdditionalModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
    };
