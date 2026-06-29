// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'phrase_pattern_model.freezed.dart';
part 'phrase_pattern_model.g.dart';

enum PhraseCategory {
  @JsonValue('opening')
  opening,
  @JsonValue('transition')
  transition,
  @JsonValue('opinion')
  opinion,
  @JsonValue('conclusion')
  conclusion,
  @JsonValue('description')
  description,
}

@freezed
abstract class PhrasePatternModel with _$PhrasePatternModel {
  const factory PhrasePatternModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'p_id') required int pId,
    required String phrase,
    @Default(<String, dynamic>{}) Map<String, dynamic> translation,
    @JsonKey(name: 'usage_context')
    @Default(<String, dynamic>{})
    Map<String, dynamic> usageContext,
    required PhraseCategory category,
    @JsonKey(name: 'audio_url') String? audioUrl,
  }) = _PhrasePatternModel;

  factory PhrasePatternModel.fromJson(Map<String, dynamic> json) =>
      _$PhrasePatternModelFromJson(json);
}
