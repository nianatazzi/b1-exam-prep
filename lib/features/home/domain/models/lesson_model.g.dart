// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => _LessonModel(
  id: json['id'] as String,
  lId: (json['l_id'] as num).toInt(),
  theme: json['theme'] as String,
);

Map<String, dynamic> _$LessonModelToJson(_LessonModel instance) =>
    <String, dynamic>{'l_id': instance.lId, 'theme': instance.theme};
