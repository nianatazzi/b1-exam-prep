// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_step_result_model.dart';
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
    // Ключ = "{lessonId}_{block}" для трёх капов упражнений урока
    // (Lesson Matrix §0 — заменяет старый "{sectionType}_{topicTId}_{prepLevel}").
    @Default(<String, StepResultModel>{})
    Map<String, StepResultModel> topicResults,
    @Default(ExerciseStatsModel()) ExerciseStatsModel stats,
    @Default(<String, AchievementModel>{})
    Map<String, AchievementModel> achievements,
    // Ключ = "{lessonId}_{oralStep}" (image/monologue/dialogue), хранится
    // только последняя попытка. Заменяет freePractice старой схемы.
    @Default(<String, LessonStepResultModel>{})
    Map<String, LessonStepResultModel> lessonResults,
  }) = _TopicProgressModel;

  factory TopicProgressModel.fromJson(Map<String, dynamic> json) =>
      _$TopicProgressModelFromJson(json);
}
