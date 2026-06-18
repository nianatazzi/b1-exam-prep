// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lexical_set_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LexicalSetModel _$LexicalSetModelFromJson(Map<String, dynamic> json) =>
    _LexicalSetModel(
      id: json['id'] as String,
      vocId: (json['voc_id'] as num).toInt(),
      title: json['title'] as String,
      translation: json['translation'] as String,
      transcription: json['transcription'] as String,
      setTitle: json['set_title'] as String,
      reward: (json['reward'] as num).toInt(),
    );

Map<String, dynamic> _$LexicalSetModelToJson(_LexicalSetModel instance) =>
    <String, dynamic>{
      'voc_id': instance.vocId,
      'title': instance.title,
      'translation': instance.translation,
      'transcription': instance.transcription,
      'set_title': instance.setTitle,
      'reward': instance.reward,
    };
