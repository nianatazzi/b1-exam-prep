// Класс GetHomeDataUseCase зависит только от domain-интерфейсов.
// Импорты data-репозиториев нужны только провайдеру ниже —
// он служит DI-мостом между domain и data.
import 'package:linguobyte/features/home/data/repositories/lesson_repository.dart';
import 'package:linguobyte/features/home/data/repositories/user_progress_repository.dart';
import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/features/home/domain/models/theory_subpart_model.dart';
import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/home/domain/repositories/i_lesson_repository.dart';
import 'package:linguobyte/features/home/domain/repositories/i_user_progress_repository.dart';
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
  final List<TheorySubpartModel> subparts;
  final LessonCardState state;

  /// 0.0 — не начат / locked, 1.0 — завершён, 0.0–1.0 — в процессе
  final double progressPercent;

  /// Номер последнего пройденного блока теории.
  /// Значим только для active-карточки — по нему вычисляется состояние субчастей.
  /// Для done/locked всегда равен 0.
  final int lastParagraph;

  const LessonCardData({
    required this.lesson,
    required this.subparts,
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
    // Параллельная загрузка через Dart 3 records — типобезопасно, без кастов
    final (lessons, progress) = await (
      lessonRepository.getLessons(langId),
      userProgressRepository.getUserLanguageProgress(userId, langId),
    ).wait;

    // Параллельно загружаем блоки теории для каждого урока
    final subpartsList = await Future.wait(
      lessons.map(
        (lesson) => lessonRepository.getTheorySubparts(langId, lesson.id),
      ),
    );

    final lessonCards = _buildLessonCards(lessons, subpartsList, progress);

    return HomeScreenData(lessonCards: lessonCards, userProgress: progress);
  }

  List<LessonCardData> _buildLessonCards(
    List<LessonModel> lessons,
    List<List<TheorySubpartModel>> subpartsList,
    UserLanguageProgressModel? progress,
  ) {
    // Нет документа прогресса — пользователь новый: первый урок активен
    if (progress == null) {
      return List.generate(lessons.length, (i) {
        return LessonCardData(
          lesson: lessons[i],
          subparts: subpartsList[i],
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
      // lastLesson == null: пользователь начинает этот язык — первый урок активен
      // lastLesson != null, но не найден в списке: урок удалён — все locked (safe fallback)
      final isNewToLanguage = progress.lastLesson == null;
      return List.generate(lessons.length, (i) {
        return LessonCardData(
          lesson: lessons[i],
          subparts: subpartsList[i],
          state: (isNewToLanguage && i == 0) ? LessonCardState.active : LessonCardState.locked,
          progressPercent: 0.0,
          lastParagraph: 0,
        );
      });
    }

    return List.generate(lessons.length, (i) {
      final lesson = lessons[i];
      final subparts = subpartsList[i];

      final LessonCardState state;
      final double progressPercent;
      final int lastParagraph;

      if (i < activeIndex) {
        state = LessonCardState.done;
        progressPercent = 1.0;
        lastParagraph = 0;
      } else if (i == activeIndex) {
        state = LessonCardState.active;
        final total = subparts.length;
        // Защита от деления на ноль если блоков теории ещё нет
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
        subparts: subparts,
        state: state,
        progressPercent: progressPercent,
        lastParagraph: lastParagraph,
      );
    });
  }
}
