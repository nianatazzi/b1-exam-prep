// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lemma_model.freezed.dart';
part 'lemma_model.g.dart';

/// Один лемматизированный токен транскрипта (Lesson Matrix §C) — LLM
/// приводит словоформу к словарной форме внутри analyzeSpeech, отдельного
/// морфологического анализатора (Morfeusz2/spaCy) не заводим.
@freezed
abstract class LemmaModel with _$LemmaModel {
  const factory LemmaModel({
    @JsonKey(name: 'surfaceForm') @Default('') String surfaceForm,
    @Default('') String lemma,
    @JsonKey(name: 'partOfSpeech') @Default('') String partOfSpeech,
  }) = _LemmaModel;

  factory LemmaModel.fromJson(Map<String, dynamic> json) =>
      _$LemmaModelFromJson(json);
}
