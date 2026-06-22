// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) =>
    _ExerciseModel(
      id: json['id'] as String,
      exId: (json['ex_id'] as num).toInt(),
      type: json['type'] as String,
      segmentType: json['segment_type'] as String,
      linkedItemId: (json['linked_item_id'] as num?)?.toInt(),
      audioUrl: json['audio_url'] as String?,
      imageUrl: json['image_url'] as String?,
      typeData: json['type_data'] as Map<String, dynamic>?,
      grammarTypes: (json['grammar_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$ExerciseModelToJson(_ExerciseModel instance) =>
    <String, dynamic>{
      'ex_id': instance.exId,
      'type': instance.type,
      'segment_type': instance.segmentType,
      'linked_item_id': instance.linkedItemId,
      'audio_url': instance.audioUrl,
      'image_url': instance.imageUrl,
      'type_data': instance.typeData,
      'grammar_types': instance.grammarTypes,
    };
