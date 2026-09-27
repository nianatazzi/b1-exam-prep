// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_turn_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DialogueTurnResultModel _$DialogueTurnResultModelFromJson(
  Map<String, dynamic> json,
) => _DialogueTurnResultModel(
  reply: json['reply'] as String? ?? '',
  turnsLeft: (json['turnsLeft'] as num?)?.toInt() ?? 0,
  shouldClose: json['shouldClose'] as bool? ?? false,
);

Map<String, dynamic> _$DialogueTurnResultModelToJson(
  _DialogueTurnResultModel instance,
) => <String, dynamic>{
  'reply': instance.reply,
  'turnsLeft': instance.turnsLeft,
  'shouldClose': instance.shouldClose,
};
