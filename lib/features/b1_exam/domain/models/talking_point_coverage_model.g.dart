// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talking_point_coverage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TalkingPointCoverageModel _$TalkingPointCoverageModelFromJson(
  Map<String, dynamic> json,
) => _TalkingPointCoverageModel(
  point: json['point'] as String? ?? '',
  covered: json['covered'] as bool? ?? false,
);

Map<String, dynamic> _$TalkingPointCoverageModelToJson(
  _TalkingPointCoverageModel instance,
) => <String, dynamic>{'point': instance.point, 'covered': instance.covered};
