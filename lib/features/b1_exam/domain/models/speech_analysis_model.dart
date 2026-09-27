// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lemma_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_error_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/talking_point_coverage_model.dart';

part 'speech_analysis_model.freezed.dart';
part 'speech_analysis_model.g.dart';

/// Результат Cloud Function analyzeSpeech (Lesson Matrix §C) — заменяет
/// более узкий FreePracticeAnalysisModel/MisusedWordModel (те привязаны к
/// старой схеме sections/topics и будут выведены из употребления при
/// перепроводке SubmitFreePracticeUseCase/ExamProgressRepository на
/// lessonResults, см. §9/§10 плана рефакторинга). analyzeSpeech знает
/// grammar_topic_id урока — поэтому отдельно считает ошибки по целевой
/// грамматике темы (targetGrammarErrors) и по всему остальному
/// (otherGrammarErrors), плюс lexicalErrors — серверная сверка (не решение
/// LLM) лемм со словарём lexical_topic_id урока.
@freezed
abstract class SpeechAnalysisModel with _$SpeechAnalysisModel {
  const factory SpeechAnalysisModel({
    @Default(<LemmaModel>[]) List<LemmaModel> lemmas,
    @JsonKey(name: 'targetGrammarErrors')
    @Default(<SpeechErrorModel>[])
    List<SpeechErrorModel> targetGrammarErrors,
    @JsonKey(name: 'otherGrammarErrors')
    @Default(<SpeechErrorModel>[])
    List<SpeechErrorModel> otherGrammarErrors,
    @JsonKey(name: 'lexicalErrors')
    @Default(<SpeechErrorModel>[])
    List<SpeechErrorModel> lexicalErrors,
    @JsonKey(name: 'talkingPointsCovered')
    @Default(<TalkingPointCoverageModel>[])
    List<TalkingPointCoverageModel> talkingPointsCovered,
    // 0-15, целостность/связность ответа — холистическая оценка LLM,
    // часть рубрики (AppConstants.speechScoreCoherenceMax).
    @JsonKey(name: 'coherenceScore') @Default(0) int coherenceScore,
  }) = _SpeechAnalysisModel;

  factory SpeechAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$SpeechAnalysisModelFromJson(json);
}
