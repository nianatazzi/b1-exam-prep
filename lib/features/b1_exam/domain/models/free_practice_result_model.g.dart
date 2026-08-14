// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_practice_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FreePracticeResultModel _$FreePracticeResultModelFromJson(
  Map<String, dynamic> json,
) => _FreePracticeResultModel(
  transcript: json['transcript'] as String? ?? '',
  durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  analysis: json['analysis'] == null
      ? null
      : FreePracticeAnalysisModel.fromJson(
          json['analysis'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$FreePracticeResultModelToJson(
  _FreePracticeResultModel instance,
) => <String, dynamic>{
  'transcript': instance.transcript,
  'durationSeconds': instance.durationSeconds,
  'completedAt': instance.completedAt?.toIso8601String(),
  'analysis': instance.analysis,
};
