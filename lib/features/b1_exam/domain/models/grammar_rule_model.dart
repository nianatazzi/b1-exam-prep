// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'grammar_rule_model.freezed.dart';
part 'grammar_rule_model.g.dart';

enum GrammarRuleType {
  @JsonValue('declension')
  declension,
  @JsonValue('conjugation')
  conjugation,
  @JsonValue('case_usage')
  caseUsage,
}

@freezed
abstract class GrammarRuleModel with _$GrammarRuleModel {
  const factory GrammarRuleModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'g_id') required int gId,
    required String title,
    @JsonKey(name: 'rule_type') required GrammarRuleType ruleType,
    @Default(<String, dynamic>{}) Map<String, dynamic> paradigm,
    @Default(<String, dynamic>{}) Map<String, dynamic> explanation,
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> examples,
  }) = _GrammarRuleModel;

  factory GrammarRuleModel.fromJson(Map<String, dynamic> json) =>
      _$GrammarRuleModelFromJson(json);
}
