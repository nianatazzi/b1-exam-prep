// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lemma_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LemmaModel _$LemmaModelFromJson(Map<String, dynamic> json) => _LemmaModel(
  surfaceForm: json['surfaceForm'] as String? ?? '',
  lemma: json['lemma'] as String? ?? '',
  partOfSpeech: json['partOfSpeech'] as String? ?? '',
);

Map<String, dynamic> _$LemmaModelToJson(_LemmaModel instance) =>
    <String, dynamic>{
      'surfaceForm': instance.surfaceForm,
      'lemma': instance.lemma,
      'partOfSpeech': instance.partOfSpeech,
    };
