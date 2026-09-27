// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

/// Блок урока (Lesson Matrix §0) — три капа по 10 упражнений на глагольное
/// спряжение / склонение существительных / фразы, все на лексике урока.
/// Заменяет старый закрытый список segment_type (vocabulary/grammar/phrases)
/// из схемы sections/topics.
enum ExerciseBlock {
  @JsonValue('verb')
  verb,
  @JsonValue('noun')
  noun,
  @JsonValue('phrase')
  phrase,
}

@freezed
abstract class ExerciseModel with _$ExerciseModel {
  const factory ExerciseModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'ex_id') required int exId,
    required String type,
    required ExerciseBlock block,
    // ссылка на GrammarRuleModel.gId для verb/noun (конкретное правило
    // спряжения/склонения). Для phrase — обычно null: фразовые упражнения
    // тренируют лексику урока (LexicalTopicModel.vocabulary), а не
    // конкретное грамматическое правило; допустимо сослаться на
    // TopicVocabularyModel.vocId, если упражнение о конкретном слове.
    @JsonKey(name: 'linked_item_id') int? linkedItemId,
    @JsonKey(name: 'audio_url') String? audioUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'type_data') Map<String, dynamic>? typeData,
    @JsonKey(name: 'grammar_types') @Default(<String>[]) List<String> grammarTypes,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
}
