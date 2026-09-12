// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_section_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_result_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/prep_step.dart';
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
    // Ключ — только через stepKey(), формат не собирать вручную.
    @Default(<String, StepResultModel>{})
    Map<String, StepResultModel> topicResults,
    @Default(ExerciseStatsModel()) ExerciseStatsModel stats,
    @Default(<String, AchievementModel>{})
    Map<String, AchievementModel> achievements,
    // Ключ — только через freePracticeKey(). Хранится последняя попытка.
    @Default(<String, FreePracticeResultModel>{})
    Map<String, FreePracticeResultModel> freePractice,
  }) = _TopicProgressModel;

  factory TopicProgressModel.fromJson(Map<String, dynamic> json) =>
      _$TopicProgressModelFromJson(json);

  /// Ключ уровня подготовки в [topicResults].
  /// Единственное место, где собирается этот формат — и на запись, и на чтение.
  ///
  /// `sectionType.key`, а не `.name`: в базе лежит `image_description`, тогда
  /// как `.name` вернул бы `imageDescription`. У [PrepLevel] такой асимметрии
  /// нет — имена значений совпадают с Firestore дословно, поэтому `.name`.
  static String stepKey({
    required ExamSectionType sectionType,
    required int topicTId,
    required PrepLevel prepLevel,
  }) =>
      '${sectionType.key}_${topicTId}_${prepLevel.name}';

  /// Ключ попытки свободной практики в [freePractice].
  static String freePracticeKey({
    required ExamSectionType sectionType,
    required int topicTId,
  }) =>
      '${sectionType.key}_$topicTId';
}
