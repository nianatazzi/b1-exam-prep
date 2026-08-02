// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TopicProgressModel _$TopicProgressModelFromJson(
  Map<String, dynamic> json,
) => _TopicProgressModel(
  id: json['id'] as String,
  topicResults:
      (json['topicResults'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, StepResultModel.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, StepResultModel>{},
  stats: json['stats'] == null
      ? const ExerciseStatsModel()
      : ExerciseStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
  achievements:
      (json['achievements'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, AchievementModel.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, AchievementModel>{},
  freePractice:
      (json['freePractice'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          FreePracticeResultModel.fromJson(e as Map<String, dynamic>),
        ),
      ) ??
      const <String, FreePracticeResultModel>{},
);

Map<String, dynamic> _$TopicProgressModelToJson(_TopicProgressModel instance) =>
    <String, dynamic>{
      'topicResults': instance.topicResults,
      'stats': instance.stats,
      'achievements': instance.achievements,
      'freePractice': instance.freePractice,
    };
