// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/misused_word_model.dart';

part 'free_practice_analysis_model.freezed.dart';
part 'free_practice_analysis_model.g.dart';

@freezed
abstract class FreePracticeAnalysisModel with _$FreePracticeAnalysisModel {
  const factory FreePracticeAnalysisModel({
    @JsonKey(name: 'misusedWords')
    @Default(<MisusedWordModel>[])
    List<MisusedWordModel> misusedWords,
  }) = _FreePracticeAnalysisModel;

  factory FreePracticeAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$FreePracticeAnalysisModelFromJson(json);
}
