// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AchievementModel _$AchievementModelFromJson(Map<String, dynamic> json) =>
    _AchievementModel(
      type: $enumDecode(_$AchievementTypeEnumMap, json['type']),
      level: (json['level'] as num?)?.toInt() ?? 0,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AchievementModelToJson(_AchievementModel instance) =>
    <String, dynamic>{
      'type': _$AchievementTypeEnumMap[instance.type]!,
      'level': instance.level,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$AchievementTypeEnumMap = {
  AchievementType.masterConjugator: 'master_conjugator',
  AchievementType.firstStep: 'first_step',
  AchievementType.focusedLearner: 'focused_learner',
  AchievementType.interestedLearner: 'interested_learner',
  AchievementType.vocabularyMaster: 'vocabulary_master',
};
