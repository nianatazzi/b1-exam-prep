// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theory_subpart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TheorySubpartModel _$TheorySubpartModelFromJson(Map<String, dynamic> json) =>
    _TheorySubpartModel(
      id: json['id'] as String,
      number: (json['number'] as num).toInt(),
      topic: json['topic'] as String,
    );

Map<String, dynamic> _$TheorySubpartModelToJson(_TheorySubpartModel instance) =>
    <String, dynamic>{'number': instance.number, 'topic': instance.topic};
