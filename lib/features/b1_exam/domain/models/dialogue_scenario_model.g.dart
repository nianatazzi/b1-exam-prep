// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_scenario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DialogueScenarioModel _$DialogueScenarioModelFromJson(
  Map<String, dynamic> json,
) => _DialogueScenarioModel(
  situation:
      json['situation'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  userRole:
      json['user_role'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  aiRole: json['ai_role'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  goal: json['goal'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  openingLine: json['opening_line'] as String? ?? '',
  maxTurns: (json['max_turns'] as num?)?.toInt() ?? 10,
);

Map<String, dynamic> _$DialogueScenarioModelToJson(
  _DialogueScenarioModel instance,
) => <String, dynamic>{
  'situation': instance.situation,
  'user_role': instance.userRole,
  'ai_role': instance.aiRole,
  'goal': instance.goal,
  'opening_line': instance.openingLine,
  'max_turns': instance.maxTurns,
};
