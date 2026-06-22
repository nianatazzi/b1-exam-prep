// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/exercise_stats_model.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';

part 'user_language_progress_model.freezed.dart';
part 'user_language_progress_model.g.dart';

@freezed
abstract class UserLanguageProgressModel with _$UserLanguageProgressModel {
  const factory UserLanguageProgressModel({
    @JsonKey(includeToJson: false) required String id,
    String? lastLesson,
    required int lastParagraph,
    @Default(ExerciseStatsModel()) ExerciseStatsModel stats,
    @Default(<String, StepResultModel>{}) Map<String, StepResultModel> stepResults,
    @Default(<String, AchievementModel>{}) Map<String, AchievementModel> achievements,
  }) = _UserLanguageProgressModel;

  factory UserLanguageProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserLanguageProgressModelFromJson(json);
}
