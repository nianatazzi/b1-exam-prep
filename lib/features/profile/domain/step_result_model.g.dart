// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StepResultModel _$StepResultModelFromJson(Map<String, dynamic> json) =>
    _StepResultModel(
      correct: (json['correct'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      firstAttempt: json['firstAttempt'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      incorrectExerciseIds:
          (json['incorrectExerciseIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$StepResultModelToJson(_StepResultModel instance) =>
    <String, dynamic>{
      'correct': instance.correct,
      'total': instance.total,
      'firstAttempt': instance.firstAttempt,
      'completedAt': instance.completedAt?.toIso8601String(),
      'incorrectExerciseIds': instance.incorrectExerciseIds,
    };
