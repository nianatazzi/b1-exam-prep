// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_language_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserLanguageProgressModel _$UserLanguageProgressModelFromJson(
  Map<String, dynamic> json,
) => _UserLanguageProgressModel(
  id: json['id'] as String,
  lastLesson: json['lastLesson'] as String?,
  lastParagraph: (json['lastParagraph'] as num).toInt(),
  stats: json['stats'] == null
      ? const ExerciseStatsModel()
      : ExerciseStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
  stepResults:
      (json['stepResults'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, StepResultModel.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, StepResultModel>{},
  achievements:
      (json['achievements'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, AchievementModel.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, AchievementModel>{},
);

Map<String, dynamic> _$UserLanguageProgressModelToJson(
  _UserLanguageProgressModel instance,
) => <String, dynamic>{
  'lastLesson': instance.lastLesson,
  'lastParagraph': instance.lastParagraph,
  'stats': instance.stats,
  'stepResults': instance.stepResults,
  'achievements': instance.achievements,
};
