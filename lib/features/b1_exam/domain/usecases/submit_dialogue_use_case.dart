import 'package:b1_exam_prep/core/logger/app_logger.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/speech_analysis_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/calculate_speech_score.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_message_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_speech_analysis_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submit_dialogue_use_case.g.dart';

@riverpod
SubmitDialogueUseCase submitDialogueUseCase(Ref ref) => SubmitDialogueUseCase(
      analysisRepository: ref.read(speechAnalysisRepositoryProvider),
      progressRepository: ref.read(examProgressRepositoryProvider),
    );

/// Финальная отправка диалога (дизайн диалога, "Implementation order" шаг 3)
/// — вызывается один раз, когда диалог завершён (shouldClose или достигнут
/// max_turns), не на каждый ход. Сами ходы к ИИ-собеседнику — прямой вызов
/// IDialogueRepository.continueDialogue из DialogueNotifier: это не
/// трансформация и не нуждается в UseCase (ARCHITECTURE.md §3, "два await
/// подряд — не логика").
class SubmitDialogueUseCase {
  final ISpeechAnalysisRepository analysisRepository;
  final IExamProgressRepository progressRepository;

  const SubmitDialogueUseCase({
    required this.analysisRepository,
    required this.progressRepository,
  });

  Future<SpeechAnalysisModel?> execute({
    required String userId,
    required String langId,
    required String lessonId,
    required List<DialogueMessageModel> turns,
    required int durationSeconds,
    required String uiLanguage,
  }) async {
    // analyzeSpeech анализирует речь СТУДЕНТА — реплики ИИ-собеседника не
    // передаём, иначе разбор считал бы их ошибки/лексику пользователя.
    final transcript = turns
        .where((t) => t.role == DialogueRole.user)
        .map((t) => t.text)
        .join(' ');

    SpeechAnalysisModel? analysis;
    int? score;
    try {
      analysis = await analysisRepository.analyze(
        langId: langId,
        lessonId: lessonId,
        oralStep: OralStep.dialogue,
        transcript: transcript,
        uiLanguage: uiLanguage,
      );
      score = calculateSpeechScore(analysis);
    } catch (e, st) {
      AppLogger.e('Dialogue analysis failed', error: e, stackTrace: st);
    }

    try {
      await progressRepository.saveLessonStepResult(
        userId: userId,
        langId: langId,
        lessonId: lessonId,
        oralStep: OralStep.dialogue,
        turns: turns,
        durationSeconds: durationSeconds,
        score: score,
        analysis: analysis,
      );
    } catch (e, st) {
      AppLogger.e('Dialogue save failed', error: e, stackTrace: st);
    }

    return analysis;
  }
}
