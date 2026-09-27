// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => _LessonModel(
  id: json['id'] as String,
  lexicalTopicId: json['lexical_topic_id'] as String,
  grammarTopicId: json['grammar_topic_id'] as String,
  imageTask: ImageTaskModel.fromJson(
    json['image_task'] as Map<String, dynamic>,
  ),
  monologueTask: FreePracticeTaskModel.fromJson(
    json['monologue_task'] as Map<String, dynamic>,
  ),
  dialogueTask: DialogueScenarioModel.fromJson(
    json['dialogue_task'] as Map<String, dynamic>,
  ),
  durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$LessonModelToJson(_LessonModel instance) =>
    <String, dynamic>{
      'lexical_topic_id': instance.lexicalTopicId,
      'grammar_topic_id': instance.grammarTopicId,
      'image_task': instance.imageTask,
      'monologue_task': instance.monologueTask,
      'dialogue_task': instance.dialogueTask,
      'duration_seconds': instance.durationSeconds,
    };
