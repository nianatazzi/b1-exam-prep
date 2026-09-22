// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrammarTopicModel _$GrammarTopicModelFromJson(Map<String, dynamic> json) =>
    _GrammarTopicModel(
      id: json['id'] as String,
      gtId: (json['gt_id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$GrammarTopicModelToJson(_GrammarTopicModel instance) =>
    <String, dynamic>{
      'gt_id': instance.gtId,
      'title': instance.title,
      'description': instance.description,
    };
