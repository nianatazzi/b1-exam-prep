// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_language_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserLanguageProgressModel _$UserLanguageProgressModelFromJson(
  Map<String, dynamic> json,
) => _UserLanguageProgressModel(
  id: json['id'] as String,
  lastLesson: json['lastLesson'] as String?,
  lastParagraph: (json['lastParagraph'] as num).toInt(),
  oralProgress: (json['oral_progress'] as num?)?.toInt() ?? 0,
  grammarProgress: (json['grammar_progress'] as num?)?.toInt() ?? 0,
  lexiconProgress: (json['lexicon_progress'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserLanguageProgressModelToJson(
  _UserLanguageProgressModel instance,
) => <String, dynamic>{
  'lastLesson': instance.lastLesson,
  'lastParagraph': instance.lastParagraph,
  'oral_progress': instance.oralProgress,
  'grammar_progress': instance.grammarProgress,
  'lexicon_progress': instance.lexiconProgress,
};
