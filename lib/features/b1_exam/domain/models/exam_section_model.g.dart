// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamSectionModel _$ExamSectionModelFromJson(Map<String, dynamic> json) =>
    _ExamSectionModel(
      id: json['id'] as String,
      sId: (json['s_id'] as num).toInt(),
      type: $enumDecode(_$ExamSectionTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );

Map<String, dynamic> _$ExamSectionModelToJson(_ExamSectionModel instance) =>
    <String, dynamic>{
      's_id': instance.sId,
      'type': _$ExamSectionTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
    };

const _$ExamSectionTypeEnumMap = {
  ExamSectionType.imageDescription: 'image_description',
  ExamSectionType.monologue: 'monologue',
  ExamSectionType.dialogue: 'dialogue',
};
