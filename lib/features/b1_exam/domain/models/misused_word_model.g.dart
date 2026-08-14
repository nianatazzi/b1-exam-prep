// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misused_word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MisusedWordModel _$MisusedWordModelFromJson(Map<String, dynamic> json) =>
    _MisusedWordModel(
      word: json['word'] as String,
      type: $enumDecode(_$MisusedWordTypeEnumMap, json['type']),
      userForm: json['userForm'] as String,
      correctForm: json['correctForm'] as String,
      explanation: json['explanation'] as String? ?? '',
    );

Map<String, dynamic> _$MisusedWordModelToJson(_MisusedWordModel instance) =>
    <String, dynamic>{
      'word': instance.word,
      'type': _$MisusedWordTypeEnumMap[instance.type]!,
      'userForm': instance.userForm,
      'correctForm': instance.correctForm,
      'explanation': instance.explanation,
    };

const _$MisusedWordTypeEnumMap = {
  MisusedWordType.verb: 'verb',
  MisusedWordType.noun: 'noun',
};
