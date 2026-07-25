// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/profile/domain/stat_entry_model.dart';

part 'exercise_stats_model.freezed.dart';
part 'exercise_stats_model.g.dart';

@freezed
abstract class ExerciseStatsModel with _$ExerciseStatsModel {
  const factory ExerciseStatsModel({
    @Default(StatEntryModel()) StatEntryModel grammar,
    @Default(StatEntryModel()) StatEntryModel vocabulary,
    @Default(StatEntryModel()) StatEntryModel listening,
    @Default(StatEntryModel()) StatEntryModel speaking,
  }) = _ExerciseStatsModel;

  factory ExerciseStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseStatsModelFromJson(json);
}
