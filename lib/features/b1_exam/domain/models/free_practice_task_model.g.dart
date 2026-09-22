// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_practice_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FreePracticeTaskModel _$FreePracticeTaskModelFromJson(
  Map<String, dynamic> json,
) => _FreePracticeTaskModel(
  prompt: json['prompt'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  points:
      (json['points'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const <Map<String, dynamic>>[],
  durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
  thinkSeconds: (json['think_seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$FreePracticeTaskModelToJson(
  _FreePracticeTaskModel instance,
) => <String, dynamic>{
  'prompt': instance.prompt,
  'points': instance.points,
  'duration_seconds': instance.durationSeconds,
  'think_seconds': instance.thinkSeconds,
};
