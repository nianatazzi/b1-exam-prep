import 'package:b1_exam_prep/core/logger/app_logger.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/free_practice_analysis_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_free_practice_analysis_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submit_free_practice_use_case.g.dart';

@riverpod
SubmitFreePracticeUseCase submitFreePracticeUseCase(Ref ref) =>
    SubmitFreePracticeUseCase(
      analysisRepository: ref.read(freePracticeAnalysisRepositoryProvider),
      progressRepository: ref.read(examProgressRepositoryProvider),
    );

/// Оркестрация завершения свободной практики (image_description, Фаза 2):
/// LLM-анализ транскрипта — best-effort, сбой (сеть, OpenAI недоступен) не
/// должен ронять сохранение транскрипта — тот же паттерн, что у streak/
/// достижений в CompleteB1StepUseCase.
class SubmitFreePracticeUseCase {
  final IFreePracticeAnalysisRepository analysisRepository;
  final IExamProgressRepository progressRepository;

  const SubmitFreePracticeUseCase({
    required this.analysisRepository,
    required this.progressRepository,
  });

  Future<FreePracticeAnalysisModel?> execute({
    required String userId,
    required String sectionType,
    required int topicTId,
    required String transcript,
    required int durationSeconds,
    required String uiLanguage,
  }) async {
    FreePracticeAnalysisModel? analysis;
    try {
      analysis = await analysisRepository.analyze(
        transcript: transcript,
        uiLanguage: uiLanguage,
      );
    } catch (e, st) {
      AppLogger.e('Free practice analysis failed', error: e, stackTrace: st);
    }

    await progressRepository.saveFreePracticeResult(
      userId: userId,
      sectionType: sectionType,
      topicTId: topicTId,
      transcript: transcript,
      durationSeconds: durationSeconds,
      analysis: analysis,
    );

    return analysis;
  }
}
