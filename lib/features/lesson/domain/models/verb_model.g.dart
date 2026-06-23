// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verb_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerbModel _$VerbModelFromJson(Map<String, dynamic> json) => _VerbModel(
  id: json['id'] as String,
  vId: (json['v_id'] as num).toInt(),
  title: json['title'] as String,
  type: json['type'] as String? ?? '',
  conjugation:
      json['conjugation'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  translation:
      json['translation'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  transcription:
      json['transcription'] as Map<String, dynamic>? ??
      const <String, dynamic>{},
);

Map<String, dynamic> _$VerbModelToJson(_VerbModel instance) =>
    <String, dynamic>{
      'v_id': instance.vId,
      'title': instance.title,
      'type': instance.type,
      'conjugation': instance.conjugation,
      'translation': instance.translation,
      'transcription': instance.transcription,
    };
