// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseStatsModel _$ExerciseStatsModelFromJson(Map<String, dynamic> json) =>
    _ExerciseStatsModel(
      grammar: json['grammar'] == null
          ? const StatEntryModel()
          : StatEntryModel.fromJson(json['grammar'] as Map<String, dynamic>),
      vocabulary: json['vocabulary'] == null
          ? const StatEntryModel()
          : StatEntryModel.fromJson(json['vocabulary'] as Map<String, dynamic>),
      listening: json['listening'] == null
          ? const StatEntryModel()
          : StatEntryModel.fromJson(json['listening'] as Map<String, dynamic>),
      speaking: json['speaking'] == null
          ? const StatEntryModel()
          : StatEntryModel.fromJson(json['speaking'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExerciseStatsModelToJson(_ExerciseStatsModel instance) =>
    <String, dynamic>{
      'grammar': instance.grammar,
      'vocabulary': instance.vocabulary,
      'listening': instance.listening,
      'speaking': instance.speaking,
    };
