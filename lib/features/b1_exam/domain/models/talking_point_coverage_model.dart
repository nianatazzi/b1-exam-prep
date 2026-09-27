// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'talking_point_coverage_model.freezed.dart';
part 'talking_point_coverage_model.g.dart';

/// Раскрыт ли один пункт задания (points_to_describe у ImageTaskModel /
/// points у FreePracticeTaskModel) в транскрипте — часть analyzeSpeech
/// (Lesson Matrix §C), участвует в task coverage части рубрики оценки.
@freezed
abstract class TalkingPointCoverageModel with _$TalkingPointCoverageModel {
  const factory TalkingPointCoverageModel({
    @Default('') String point,
    @Default(false) bool covered,
  }) = _TalkingPointCoverageModel;

  factory TalkingPointCoverageModel.fromJson(Map<String, dynamic> json) =>
      _$TalkingPointCoverageModelFromJson(json);
}
