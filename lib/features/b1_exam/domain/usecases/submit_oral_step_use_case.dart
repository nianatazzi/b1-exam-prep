import 'package:b1_exam_prep/core/logger/app_logger.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/speech_analysis_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/calculate_speech_score.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_speech_analysis_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submit_oral_step_use_case.g.dart';

@riverpod
SubmitOralStepUseCase submitOralStepUseCase(Ref ref) => SubmitOralStepUseCase(
      analysisRepository: ref.read(speechAnalysisRepositoryProvider),
      progressRepository: ref.read(examProgressRepositoryProvider),
    );

/// Оркестрация завершения устного шага image/monologue (Lesson Matrix §C) —
/// генерализация бывшего SubmitFreePracticeUseCase на lessonId/oralStep.
/// Диалог не проходит через этот use case — там ход за ходом идёт напрямую
/// через IDialogueRepository (DialogueNotifier), а финальная отправка всей
/// истории — отдельный SubmitDialogueUseCase (turns вместо transcript).
/// LLM-анализ — best-effort, сбой не должен ронять сохранение транскрипта —
/// тот же паттерн, что у streak/достижений в CompleteB1StepUseCase.
class SubmitOralStepUseCase {
  final ISpeechAnalysisRepository analysisRepository;
  final IExamProgressRepository progressRepository;

  const SubmitOralStepUseCase({
    required this.analysisRepository,
    required this.progressRepository,
  });

  Future<SpeechAnalysisModel?> execute({
    required String userId,
    required String langId,
    required String lessonId,
    required OralStep oralStep,
    required String transcript,
    required int durationSeconds,
    required String uiLanguage,
  }) async {
    SpeechAnalysisModel? analysis;
    int? score;
    try {
      analysis = await analysisRepository.analyze(
        langId: langId,
        lessonId: lessonId,
        oralStep: oralStep,
        transcript: transcript,
        uiLanguage: uiLanguage,
      );
      score = calculateSpeechScore(analysis);
    } catch (e, st) {
      AppLogger.e('Speech analysis failed', error: e, stackTrace: st);
    }

    try {
      await progressRepository.saveLessonStepResult(
        userId: userId,
        langId: langId,
        lessonId: lessonId,
        oralStep: oralStep,
        transcript: transcript,
        durationSeconds: durationSeconds,
        score: score,
        analysis: analysis,
      );
    } catch (e, st) {
      // Best-effort, как и анализ: при таймауте/сети запись уже стоит в
      // офлайн-очереди Firestore и досинкается сама — не блокируем экран
      // результата ожиданием подтверждения от сервера.
      AppLogger.e('Lesson step save failed', error: e, stackTrace: st);
    }

    return analysis;
  }
}
