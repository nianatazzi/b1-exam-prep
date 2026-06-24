// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TheoryModel _$TheoryModelFromJson(Map<String, dynamic> json) => _TheoryModel(
  id: json['id'] as String,
  thId: (json['th_id'] as num).toInt(),
  topic: json['topic'] as String,
  title: json['title'] as String,
  text: json['text'] as String,
  video: json['video'] as String?,
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  reward: (json['reward'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TheoryModelToJson(_TheoryModel instance) =>
    <String, dynamic>{
      'th_id': instance.thId,
      'topic': instance.topic,
      'title': instance.title,
      'text': instance.text,
      'video': instance.video,
      'duration': instance.duration,
      'reward': instance.reward,
    };
