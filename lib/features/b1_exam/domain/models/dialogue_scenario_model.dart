// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialogue_scenario_model.freezed.dart';
part 'dialogue_scenario_model.g.dart';

/// Сценарий шага "диалог" урока (Lesson Matrix §A, дизайн диалога).
/// `situation`/`userRole`/`aiRole`/`goal` — тексты по коду языка интерфейса,
/// та же форма, что у `explanation` в GrammarRuleModel. `openingLine` — первая реплика ИИ-собеседника, всегда на польском (не
/// переводится). `maxTurns` — жёсткий потолок реплик, проверяется и на
/// сервере в continueDialogue, не только в UI.
@freezed
abstract class DialogueScenarioModel with _$DialogueScenarioModel {
  const factory DialogueScenarioModel({
    @Default(<String, dynamic>{}) Map<String, dynamic> situation,
    @JsonKey(name: 'user_role')
    @Default(<String, dynamic>{})
    Map<String, dynamic> userRole,
    @JsonKey(name: 'ai_role')
    @Default(<String, dynamic>{})
    Map<String, dynamic> aiRole,
    @Default(<String, dynamic>{}) Map<String, dynamic> goal,
    @JsonKey(name: 'opening_line') @Default('') String openingLine,
    @JsonKey(name: 'max_turns') @Default(10) int maxTurns,
  }) = _DialogueScenarioModel;

  factory DialogueScenarioModel.fromJson(Map<String, dynamic> json) =>
      _$DialogueScenarioModelFromJson(json);
}
