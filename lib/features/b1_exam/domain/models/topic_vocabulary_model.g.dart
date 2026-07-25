// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_vocabulary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TopicVocabularyModel _$TopicVocabularyModelFromJson(
  Map<String, dynamic> json,
) => _TopicVocabularyModel(
  id: json['id'] as String,
  vocId: (json['voc_id'] as num).toInt(),
  word: json['word'] as String,
  translation:
      json['translation'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  transcription: json['transcription'] as String? ?? '',
  gender: json['gender'] as String?,
  exampleSentence:
      json['example_sentence'] as Map<String, dynamic>? ??
      const <String, dynamic>{},
  audioUrl: json['audio_url'] as String?,
);

Map<String, dynamic> _$TopicVocabularyModelToJson(
  _TopicVocabularyModel instance,
) => <String, dynamic>{
  'voc_id': instance.vocId,
  'word': instance.word,
  'translation': instance.translation,
  'transcription': instance.transcription,
  'gender': instance.gender,
  'example_sentence': instance.exampleSentence,
  'audio_url': instance.audioUrl,
};
