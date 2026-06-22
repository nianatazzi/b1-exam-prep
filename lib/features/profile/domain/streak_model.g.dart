// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreakModel _$StreakModelFromJson(Map<String, dynamic> json) => _StreakModel(
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
  lastActiveDate: json['lastActiveDate'] == null
      ? null
      : DateTime.parse(json['lastActiveDate'] as String),
);

Map<String, dynamic> _$StreakModelToJson(_StreakModel instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'bestStreak': instance.bestStreak,
      'lastActiveDate': instance.lastActiveDate?.toIso8601String(),
    };
