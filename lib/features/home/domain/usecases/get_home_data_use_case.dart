// Класс GetHomeDataUseCase зависит только от domain-интерфейсов.
// Импорты data-репозиториев нужны только провайдеру ниже —
// он служит DI-мостом между domain и data.
import 'package:linguobyte/features/home/data/repositories/lesson_repository.dart';
import 'package:linguobyte/features/home/data/repositories/user_progress_repository.dart';
import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/home/domain/repositories/i_lesson_repository.dart';
import 'package:linguobyte/features/home/domain/repositories/i_user_progress_repository.dart';
import 'package:linguobyte/shared/models/lesson_step_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_home_data_use_case.g.dart';

@riverpod
GetHomeDataUseCase getHomeDataUseCase(Ref ref) => GetHomeDataUseCase(
      lessonRepository: ref.watch(lessonRepositoryProvider),
      userProgressRepository: ref.watch(userProgressRepositoryProvider),
    );

// ── Вспомогательные domain-объекты ──────────────────────────────────────────

enum LessonCardState { done, active, locked }

class LessonCardData {
  final LessonModel lesson;
  final List<LessonStepSummary> steps;
  final LessonCardState state;

  /// 0.0 — не начат / locked, 1.0 — завершён, 0.0–1.0 — в процессе
  final double progressPercent;

  /// Количество завершённых шагов (= lastParagraph из Firestore).
  /// Значим только для active-карточки.
  final int lastParagraph;

  const LessonCardData({
    required this.lesson,
    required this.steps,
    required this.state,
    required this.progressPercent,
    required this.lastParagraph,
  });
}

class HomeScreenData {
  final List<LessonCardData> lessonCards;
  final UserLanguageProgressModel? userProgress;

  const HomeScreenData({
    required this.lessonCards,
    required this.userProgress,
  });
}

// ── UseCase ──────────────────────────────────────────────────────────────────

class GetHomeDataUseCase {
  final ILessonRepository lessonRepository;
  final IUserProgressRepository userProgressRepository;

  const GetHomeDataUseCase({
    required this.lessonRepository,
    required this.userProgressRepository,
  });

  /// Объединяет данные из basic/ и private_user_info/,
  /// вычисляет состояние каждой карточки урока.
  /// AppError из репозиториев пробрасывается без перехвата.
  Future<HomeScreenData> execute(String userId, String langId) async {
    final (lessons, progress) = await (
      lessonRepository.getLessons(langId),
      userProgressRepository.getUserLanguageProgress(userId, langId),
    ).wait;

    // Параллельно загружаем сводку шагов для каждого урока
    final stepsList = await Future.wait(
      lessons.map(
        (lesson) =>
            lessonRepository.getLessonStepSummaries(langId, lesson.id),
      ),
    );

    final lessonCards = _buildLessonCards(lessons, stepsList, progress);

    return HomeScreenData(lessonCards: lessonCards, userProgress: progress);
  }

  List<LessonCardData> _buildLessonCards(
    List<LessonModel> lessons,
    List<List<LessonStepSummary>> stepsList,
    UserLanguageProgressModel? progress,
  ) {
    if (progress == null) {
      return List.generate(lessons.length, (i) {
        return LessonCardData(
          lesson: lessons[i],
          steps: stepsList[i],
          state: i == 0 ? LessonCardState.active : LessonCardState.locked,
          progressPercent: 0.0,
          lastParagraph: 0,
        );
      });
    }

    final activeIndex = lessons.indexWhere(
      (lesson) => lesson.id == progress.lastLesson,
    );

    if (activeIndex == -1) {
      // lastLesson == null (новый язык) или урок не найден в списке (orphaned id):
      // первый урок всегда доступен — пользователь не должен оказаться в тупике.
      return List.generate(lessons.length, (i) {
        return LessonCardData(
          lesson: lessons[i],
          steps: stepsList[i],
          state: i == 0 ? LessonCardState.active : LessonCardState.locked,
          progressPercent: 0.0,
          lastParagraph: 0,
        );
      });
    }

    return List.generate(lessons.length, (i) {
      final lesson = lessons[i];
      final steps = stepsList[i];

      final LessonCardState state;
      final double progressPercent;
      final int lastParagraph;

      if (i < activeIndex) {
        state = LessonCardState.done;
        progressPercent = 1.0;
        lastParagraph = 0;
      } else if (i == activeIndex) {
        state = LessonCardState.active;
        final total = steps.length;
        progressPercent = total > 0
            ? (progress.lastParagraph / total).clamp(0.0, 1.0)
            : 0.0;
        lastParagraph = progress.lastParagraph;
      } else {
        state = LessonCardState.locked;
        progressPercent = 0.0;
        lastParagraph = 0;
      }

      return LessonCardData(
        lesson: lesson,
        steps: steps,
        state: state,
        progressPercent: progressPercent,
        lastParagraph: lastParagraph,
      );
    });
  }
}
