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
    @JsonKey(name: 'oral_progress') required int oralProgress,
    @JsonKey(name: 'grammar_progress') required int grammarProgress,
    @JsonKey(name: 'lexicon_progress') required int lexiconProgress,
  }) = _UserLanguageProgressModel;

  factory UserLanguageProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserLanguageProgressModelFromJson(json);
}
