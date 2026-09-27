// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DialogueMessageModel _$DialogueMessageModelFromJson(
  Map<String, dynamic> json,
) => _DialogueMessageModel(
  role: $enumDecode(_$DialogueRoleEnumMap, json['role']),
  text: json['text'] as String,
);

Map<String, dynamic> _$DialogueMessageModelToJson(
  _DialogueMessageModel instance,
) => <String, dynamic>{
  'role': _$DialogueRoleEnumMap[instance.role]!,
  'text': instance.text,
};

const _$DialogueRoleEnumMap = {
  DialogueRole.user: 'user',
  DialogueRole.ai: 'ai',
};
