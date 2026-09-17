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
      freePracticeTask: json['free_practice_task'] == null
          ? null
          : FreePracticeTaskModel.fromJson(
              json['free_practice_task'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ExamTopicModelToJson(_ExamTopicModel instance) =>
    <String, dynamic>{
      't_id': instance.tId,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'free_practice_task': instance.freePracticeTask,
    };
