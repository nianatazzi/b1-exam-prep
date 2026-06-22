// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stat_entry_model.freezed.dart';
part 'stat_entry_model.g.dart';

@freezed
abstract class StatEntryModel with _$StatEntryModel {
  const StatEntryModel._();

  const factory StatEntryModel({
    @Default(0) int correct,
    @Default(0) int total,
  }) = _StatEntryModel;

  factory StatEntryModel.fromJson(Map<String, dynamic> json) =>
      _$StatEntryModelFromJson(json);

  int get percent => total == 0 ? 0 : (correct / total * 100).round();
}
