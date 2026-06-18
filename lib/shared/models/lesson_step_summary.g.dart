// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_step_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonStepSummary _$LessonStepSummaryFromJson(Map<String, dynamic> json) =>
    _LessonStepSummary(
      type: $enumDecode(_$LessonStepTypeEnumMap, json['type']),
      title: json['title'] as String,
    );

Map<String, dynamic> _$LessonStepSummaryToJson(_LessonStepSummary instance) =>
    <String, dynamic>{
      'type': _$LessonStepTypeEnumMap[instance.type]!,
      'title': instance.title,
    };

const _$LessonStepTypeEnumMap = {
  LessonStepType.theory: 'theory',
  LessonStepType.lexical: 'lexical',
  LessonStepType.verbs: 'verbs',
};
