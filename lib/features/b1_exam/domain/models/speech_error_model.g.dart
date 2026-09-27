// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpeechErrorModel _$SpeechErrorModelFromJson(Map<String, dynamic> json) =>
    _SpeechErrorModel(
      word: json['word'] as String? ?? '',
      userForm: json['userForm'] as String? ?? '',
      correctForm: json['correctForm'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );

Map<String, dynamic> _$SpeechErrorModelToJson(_SpeechErrorModel instance) =>
    <String, dynamic>{
      'word': instance.word,
      'userForm': instance.userForm,
      'correctForm': instance.correctForm,
      'explanation': instance.explanation,
    };
