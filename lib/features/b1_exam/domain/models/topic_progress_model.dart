// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_result_model.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';
import 'package:b1_exam_prep/features/profile/domain/exercise_stats_model.dart';
import 'package:b1_exam_prep/features/profile/domain/step_result_model.dart';

part 'topic_progress_model.freezed.dart';
part 'topic_progress_model.g.dart';

/// Прогресс пользователя по B1 Polish exam prep — изолирован от
/// languages/{langId} (см. FIRESTORE.md §4), но использует ту же форму
/// stats/achievements, что и linguobyte, для единого ProfileScreen.
@freezed
abstract class TopicProgressModel with _$TopicProgressModel {
  const factory TopicProgressModel({
    @JsonKey(includeToJson: false) required String id,
    @Default(<String, StepResultModel>{})
    Map<String, StepResultModel> topicResults,
    @Default(ExerciseStatsModel()) ExerciseStatsModel stats,
    @Default(<String, AchievementModel>{})
    Map<String, AchievementModel> achievements,
    // Ключ = "{sectionType}_{topicTId}", хранится только последняя попытка.
    @Default(<String, FreePracticeResultModel>{})
    Map<String, FreePracticeResultModel> freePractice,
  }) = _TopicProgressModel;

  factory TopicProgressModel.fromJson(Map<String, dynamic> json) =>
      _$TopicProgressModelFromJson(json);
}
