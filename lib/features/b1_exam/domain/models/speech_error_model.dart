// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_error_model.freezed.dart';
part 'speech_error_model.g.dart';

/// Одна ошибка из анализа речи (Lesson Matrix §C) — общая форма для
/// targetGrammarErrors/otherGrammarErrors/lexicalErrors в SpeechAnalysisModel,
/// списки различаются тем, В КАКОМ поле они лежат, а не типом элемента.
@freezed
abstract class SpeechErrorModel with _$SpeechErrorModel {
  const factory SpeechErrorModel({
    @Default('') String word,
    @JsonKey(name: 'userForm') @Default('') String userForm,
    @JsonKey(name: 'correctForm') @Default('') String correctForm,
    @Default('') String explanation,
  }) = _SpeechErrorModel;

  factory SpeechErrorModel.fromJson(Map<String, dynamic> json) =>
      _$SpeechErrorModelFromJson(json);
}
