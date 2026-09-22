// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lexical_topic_model.freezed.dart';
part 'lexical_topic_model.g.dart';

/// Лексическая тема ("Restauracja", "Hotel", "Szkoła"…) — одна из двух осей
/// урока (Lesson Matrix §A). Вторая ось — GrammarTopicModel, их пара
/// образует урок (LessonModel). Словарь темы — подколлекция vocabulary/
/// того же вида TopicVocabularyModel, что и раньше, просто вложена под
/// lexical_topics/{id} вместо sections/{sectionId}/topics/{topicId}.
@freezed
abstract class LexicalTopicModel with _$LexicalTopicModel {
  const factory LexicalTopicModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'lt_id') required int ltId,
    required String title,
    @Default('') String description,
  }) = _LexicalTopicModel;

  factory LexicalTopicModel.fromJson(Map<String, dynamic> json) =>
      _$LexicalTopicModelFromJson(json);
}
