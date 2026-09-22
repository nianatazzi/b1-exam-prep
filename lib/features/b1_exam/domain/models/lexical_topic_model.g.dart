// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lexical_topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LexicalTopicModel _$LexicalTopicModelFromJson(Map<String, dynamic> json) =>
    _LexicalTopicModel(
      id: json['id'] as String,
      ltId: (json['lt_id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$LexicalTopicModelToJson(_LexicalTopicModel instance) =>
    <String, dynamic>{
      'lt_id': instance.ltId,
      'title': instance.title,
      'description': instance.description,
    };
