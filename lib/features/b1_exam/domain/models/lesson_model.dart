// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_scenario_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_task_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/image_task_model.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

/// Урок — пара «лексическая тема + грамматическая тема» (Lesson Matrix §A).
/// Один `lexicalTopicId` может встречаться в нескольких уроках с разными
/// `grammarTopicId` — пара не биективна, отдельной junction-коллекции нет,
/// гибкость — просто в том, сколько документов урока заведено (см. §F).
///
/// `monologueTask` переиспользует уже готовый FreePracticeTaskModel (15d3caa)
/// как есть — форма задания для монолога не менялась.
///
/// `durationSeconds` — nullable, не с числовым дефолтом: та же причина, что у
/// `FreePracticeTaskModel.durationSeconds` — null означает «в контенте не
/// задано», конкретное значение по умолчанию (3 минуты) подставляет
/// presentation-слой из AppConstants, а не модель.
@freezed
abstract class LessonModel with _$LessonModel {
  const factory LessonModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'lexical_topic_id') required String lexicalTopicId,
    @JsonKey(name: 'grammar_topic_id') required String grammarTopicId,
    @JsonKey(name: 'image_task') required ImageTaskModel imageTask,
    @JsonKey(name: 'monologue_task') required FreePracticeTaskModel monologueTask,
    @JsonKey(name: 'dialogue_task') required DialogueScenarioModel dialogueTask,
    @JsonKey(name: 'duration_seconds') int? durationSeconds,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}
