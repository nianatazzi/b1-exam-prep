// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_step_summary.freezed.dart';
part 'lesson_step_summary.g.dart';

enum LessonStepType {
  @JsonValue('theory')
  theory,
  @JsonValue('lexical')
  lexical,
  @JsonValue('verbs')
  verbs,
  // final — зарезервированное слово, поэтому finalStep с JsonValue 'final'
  @JsonValue('final')
  finalStep,
}

@freezed
abstract class LessonStepSummary with _$LessonStepSummary {
  const factory LessonStepSummary({
    required LessonStepType type,
    // topic для theory, set_title для lexical, '' для verbs (виджет подставит ARB)
    required String title,
  }) = _LessonStepSummary;

  factory LessonStepSummary.fromJson(Map<String, dynamic> json) =>
      _$LessonStepSummaryFromJson(json);
}
