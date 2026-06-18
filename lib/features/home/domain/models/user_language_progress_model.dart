// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_language_progress_model.freezed.dart';
part 'user_language_progress_model.g.dart';

@freezed
abstract class UserLanguageProgressModel with _$UserLanguageProgressModel {
  const factory UserLanguageProgressModel({
    // id берётся из DocumentSnapshot.id — не хранится в теле документа
    @JsonKey(includeToJson: false) required String id,
    // null = новый пользователь, все уроки locked
    String? lastLesson,
    required int lastParagraph,
    // @Default(0) — документ прогресса может быть создан частично (updateProgress
    // пишет только lastLesson/lastParagraph). Эти поля — заглушки детального
    // прогресса; реальные значения, когда появятся, читаются как обычно.
    @JsonKey(name: 'oral_progress') @Default(0) int oralProgress,
    @JsonKey(name: 'grammar_progress') @Default(0) int grammarProgress,
    @JsonKey(name: 'lexicon_progress') @Default(0) int lexiconProgress,
  }) = _UserLanguageProgressModel;

  factory UserLanguageProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserLanguageProgressModelFromJson(json);
}
