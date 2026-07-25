// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamTopicModel _$ExamTopicModelFromJson(Map<String, dynamic> json) =>
    _ExamTopicModel(
      id: json['id'] as String,
      tId: (json['t_id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$ExamTopicModelToJson(_ExamTopicModel instance) =>
    <String, dynamic>{
      't_id': instance.tId,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
    };
