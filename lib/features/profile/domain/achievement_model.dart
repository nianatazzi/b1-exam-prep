// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_model.freezed.dart';
part 'achievement_model.g.dart';

enum AchievementType {
  @JsonValue('master_conjugator')
  masterConjugator,
  @JsonValue('first_step')
  firstStep,
  @JsonValue('focused_learner')
  focusedLearner,
  @JsonValue('interested_learner')
  interestedLearner,
  @JsonValue('vocabulary_master')
  vocabularyMaster,
}

extension AchievementTypeKey on AchievementType {
  /// Строковый ключ достижения (= JsonValue). Единственный источник —
  /// сгенерированная `_$AchievementTypeEnumMap`, без ручных switch-копий.
  String get key => _$AchievementTypeEnumMap[this]!;
}

@freezed
abstract class AchievementModel with _$AchievementModel {
  const factory AchievementModel({
    required AchievementType type,
    @Default(0) int level,
    DateTime? updatedAt,
  }) = _AchievementModel;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);
}
