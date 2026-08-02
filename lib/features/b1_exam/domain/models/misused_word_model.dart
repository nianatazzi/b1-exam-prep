// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'misused_word_model.freezed.dart';
part 'misused_word_model.g.dart';

enum MisusedWordType {
  @JsonValue('verb')
  verb,
  @JsonValue('noun')
  noun,
}

/// Один неправильно использованный глагол/существительное из транскрипта
/// свободной практики — результат LLM-анализа (Фаза 2, analyzeFreePractice
/// Cloud Function). Используется для повторной тренировки конкретных слов.
@freezed
abstract class MisusedWordModel with _$MisusedWordModel {
  const factory MisusedWordModel({
    required String word,
    required MisusedWordType type,
    @JsonKey(name: 'userForm') required String userForm,
    @JsonKey(name: 'correctForm') required String correctForm,
    @Default('') String explanation,
  }) = _MisusedWordModel;

  factory MisusedWordModel.fromJson(Map<String, dynamic> json) =>
      _$MisusedWordModelFromJson(json);
}
