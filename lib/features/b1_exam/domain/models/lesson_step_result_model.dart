// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_message_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_analysis_model.dart';

part 'lesson_step_result_model.freezed.dart';
part 'lesson_step_result_model.g.dart';

/// Результат одного устного шага урока (image/monologue/dialogue) — хранится
/// в TopicProgressModel.lessonResults, ключ "{lessonId}_{oralStep}", только
/// последняя попытка (Lesson Matrix, дизайн диалога, "Progress storage").
/// [transcript] заполнен для image/monologue (одна запись), [turns] — для
/// dialogue (история реплик); поля взаимоисключающие, различаются по шагу,
/// не отдельными подклассами — так документ читается одинаково независимо
/// от oralStep, без discriminated union на стороне Firestore.
@freezed
abstract class LessonStepResultModel with _$LessonStepResultModel {
  const factory LessonStepResultModel({
    String? transcript,
    @Default(<DialogueMessageModel>[]) List<DialogueMessageModel> turns,
    @JsonKey(name: 'durationSeconds') @Default(0) int durationSeconds,
    DateTime? completedAt,
    int? score,
    SpeechAnalysisModel? analysis,
  }) = _LessonStepResultModel;

  factory LessonStepResultModel.fromJson(Map<String, dynamic> json) =>
      _$LessonStepResultModelFromJson(json);
}
