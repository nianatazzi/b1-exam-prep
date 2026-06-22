// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'step_result_model.freezed.dart';
part 'step_result_model.g.dart';

@freezed
abstract class StepResultModel with _$StepResultModel {
  const factory StepResultModel({
    @Default(0) int correct,
    @Default(0) int total,
    @Default(false) bool firstAttempt,
    DateTime? completedAt,
    @Default(<String>[]) List<String> incorrectExerciseIds,
  }) = _StepResultModel;

  factory StepResultModel.fromJson(Map<String, dynamic> json) =>
      _$StepResultModelFromJson(json);
}
