// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_analysis_model.dart';

part 'free_practice_result_model.freezed.dart';
part 'free_practice_result_model.g.dart';

/// Результат свободной практики (image_description): транскрипт записи
/// пользователя за сессию таймера + результат LLM-анализа (Фаза 2,
/// analyzeFreePractice Cloud Function). [analysis] может быть null — вызов
/// LLM не критичен для завершения топика (см. SubmitFreePracticeUseCase).
@freezed
abstract class FreePracticeResultModel with _$FreePracticeResultModel {
  const factory FreePracticeResultModel({
    @Default('') String transcript,
    @JsonKey(name: 'durationSeconds') @Default(0) int durationSeconds,
    DateTime? completedAt,
    FreePracticeAnalysisModel? analysis,
  }) = _FreePracticeResultModel;

  factory FreePracticeResultModel.fromJson(Map<String, dynamic> json) =>
      _$FreePracticeResultModelFromJson(json);
}
