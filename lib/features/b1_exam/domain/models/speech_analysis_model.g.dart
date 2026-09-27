// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpeechAnalysisModel _$SpeechAnalysisModelFromJson(Map<String, dynamic> json) =>
    _SpeechAnalysisModel(
      lemmas:
          (json['lemmas'] as List<dynamic>?)
              ?.map((e) => LemmaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <LemmaModel>[],
      targetGrammarErrors:
          (json['targetGrammarErrors'] as List<dynamic>?)
              ?.map((e) => SpeechErrorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SpeechErrorModel>[],
      otherGrammarErrors:
          (json['otherGrammarErrors'] as List<dynamic>?)
              ?.map((e) => SpeechErrorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SpeechErrorModel>[],
      lexicalErrors:
          (json['lexicalErrors'] as List<dynamic>?)
              ?.map((e) => SpeechErrorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SpeechErrorModel>[],
      talkingPointsCovered:
          (json['talkingPointsCovered'] as List<dynamic>?)
              ?.map(
                (e) => TalkingPointCoverageModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const <TalkingPointCoverageModel>[],
      coherenceScore: (json['coherenceScore'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SpeechAnalysisModelToJson(
  _SpeechAnalysisModel instance,
) => <String, dynamic>{
  'lemmas': instance.lemmas,
  'targetGrammarErrors': instance.targetGrammarErrors,
  'otherGrammarErrors': instance.otherGrammarErrors,
  'lexicalErrors': instance.lexicalErrors,
  'talkingPointsCovered': instance.talkingPointsCovered,
  'coherenceScore': instance.coherenceScore,
};
