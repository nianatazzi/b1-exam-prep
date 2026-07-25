// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phrase_pattern_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhrasePatternModel _$PhrasePatternModelFromJson(Map<String, dynamic> json) =>
    _PhrasePatternModel(
      id: json['id'] as String,
      pId: (json['p_id'] as num).toInt(),
      phrase: json['phrase'] as String,
      translation:
          json['translation'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      usageContext:
          json['usage_context'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      category: $enumDecode(_$PhraseCategoryEnumMap, json['category']),
      audioUrl: json['audio_url'] as String?,
    );

Map<String, dynamic> _$PhrasePatternModelToJson(_PhrasePatternModel instance) =>
    <String, dynamic>{
      'p_id': instance.pId,
      'phrase': instance.phrase,
      'translation': instance.translation,
      'usage_context': instance.usageContext,
      'category': _$PhraseCategoryEnumMap[instance.category]!,
      'audio_url': instance.audioUrl,
    };

const _$PhraseCategoryEnumMap = {
  PhraseCategory.opening: 'opening',
  PhraseCategory.transition: 'transition',
  PhraseCategory.opinion: 'opinion',
  PhraseCategory.conclusion: 'conclusion',
  PhraseCategory.description: 'description',
};
