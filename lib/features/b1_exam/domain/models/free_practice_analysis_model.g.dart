// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_practice_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FreePracticeAnalysisModel _$FreePracticeAnalysisModelFromJson(
  Map<String, dynamic> json,
) => _FreePracticeAnalysisModel(
  misusedWords:
      (json['misusedWords'] as List<dynamic>?)
          ?.map((e) => MisusedWordModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MisusedWordModel>[],
);

Map<String, dynamic> _$FreePracticeAnalysisModelToJson(
  _FreePracticeAnalysisModel instance,
) => <String, dynamic>{'misusedWords': instance.misusedWords};
