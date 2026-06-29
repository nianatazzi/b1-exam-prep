// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';

part 'topic_progress_model.freezed.dart';
part 'topic_progress_model.g.dart';

@freezed
abstract class TopicProgressModel with _$TopicProgressModel {
  const factory TopicProgressModel({
    @JsonKey(includeToJson: false) required String id,
    @Default(<String, StepResultModel>{})
    Map<String, StepResultModel> topicResults,
    @Default(B1StatsModel()) B1StatsModel stats,
  }) = _TopicProgressModel;

  factory TopicProgressModel.fromJson(Map<String, dynamic> json) =>
      _$TopicProgressModelFromJson(json);
}

@freezed
abstract class B1StatsModel with _$B1StatsModel {
  const factory B1StatsModel({
    @Default(B1StatEntry()) B1StatEntry vocabulary,
    @Default(B1StatEntry()) B1StatEntry grammar,
    @Default(B1StatEntry()) B1StatEntry phrases,
  }) = _B1StatsModel;

  factory B1StatsModel.fromJson(Map<String, dynamic> json) =>
      _$B1StatsModelFromJson(json);
}

@freezed
abstract class B1StatEntry with _$B1StatEntry {
  const factory B1StatEntry({
    @Default(0) int correct,
    @Default(0) int total,
  }) = _B1StatEntry;

  factory B1StatEntry.fromJson(Map<String, dynamic> json) =>
      _$B1StatEntryFromJson(json);
}
