// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'grammar_topic_model.freezed.dart';
part 'grammar_topic_model.g.dart';

/// Грамматическая тема ("Celownik"/дательный, "Tryb warunkowy"/условное
/// наклонение, "Stopień najwyższy"/превосходная степень…) — вторая ось урока
/// (см. LexicalTopicModel). Конкретные правила — подколлекция rules/ из
/// GrammarRuleModel без изменения формы (см. расширение ruleType значениями
/// mood/degree там же — Lesson Matrix §0).
@freezed
abstract class GrammarTopicModel with _$GrammarTopicModel {
  const factory GrammarTopicModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'gt_id') required int gtId,
    required String title,
    @Default('') String description,
  }) = _GrammarTopicModel;

  factory GrammarTopicModel.fromJson(Map<String, dynamic> json) =>
      _$GrammarTopicModelFromJson(json);
}
