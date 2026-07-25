// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_rule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrammarRuleModel _$GrammarRuleModelFromJson(
  Map<String, dynamic> json,
) => _GrammarRuleModel(
  id: json['id'] as String,
  gId: (json['g_id'] as num).toInt(),
  title: json['title'] as String,
  ruleType: $enumDecode(_$GrammarRuleTypeEnumMap, json['rule_type']),
  paradigm:
      json['paradigm'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  explanation:
      json['explanation'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  examples:
      (json['examples'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const <Map<String, dynamic>>[],
);

Map<String, dynamic> _$GrammarRuleModelToJson(_GrammarRuleModel instance) =>
    <String, dynamic>{
      'g_id': instance.gId,
      'title': instance.title,
      'rule_type': _$GrammarRuleTypeEnumMap[instance.ruleType]!,
      'paradigm': instance.paradigm,
      'explanation': instance.explanation,
      'examples': instance.examples,
    };

const _$GrammarRuleTypeEnumMap = {
  GrammarRuleType.declension: 'declension',
  GrammarRuleType.conjugation: 'conjugation',
  GrammarRuleType.caseUsage: 'case_usage',
};
