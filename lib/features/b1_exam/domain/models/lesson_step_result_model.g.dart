// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_step_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonStepResultModel _$LessonStepResultModelFromJson(
  Map<String, dynamic> json,
) => _LessonStepResultModel(
  transcript: json['transcript'] as String?,
  turns:
      (json['turns'] as List<dynamic>?)
          ?.map((e) => DialogueMessageModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DialogueMessageModel>[],
  durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  score: (json['score'] as num?)?.toInt(),
  analysis: json['analysis'] == null
      ? null
      : SpeechAnalysisModel.fromJson(json['analysis'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LessonStepResultModelToJson(
  _LessonStepResultModel instance,
) => <String, dynamic>{
  'transcript': instance.transcript,
  'turns': instance.turns,
  'durationSeconds': instance.durationSeconds,
  'completedAt': instance.completedAt?.toIso8601String(),
  'score': instance.score,
  'analysis': instance.analysis,
};
