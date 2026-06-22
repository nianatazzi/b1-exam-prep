// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StatEntryModel _$StatEntryModelFromJson(Map<String, dynamic> json) =>
    _StatEntryModel(
      correct: (json['correct'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StatEntryModelToJson(_StatEntryModel instance) =>
    <String, dynamic>{'correct': instance.correct, 'total': instance.total};
