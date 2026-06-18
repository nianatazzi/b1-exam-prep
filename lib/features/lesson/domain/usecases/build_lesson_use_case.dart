import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/home/data/repositories/lesson_repository.dart';
import 'package:linguobyte/features/home/data/repositories/user_progress_repository.dart';
import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/features/home/domain/repositories/i_lesson_repository.dart';
import 'package:linguobyte/features/home/domain/repositories/i_user_progress_repository.dart';
import 'package:linguobyte/features/lesson/data/repositories/exercise_repository.dart';
import 'package:linguobyte/features/lesson/data/repositories/lesson_content_repository.dart';
import 'package:linguobyte/features/lesson/domain/models/additional_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/domain/repositories/i_exercise_repository.dart';
import 'package:linguobyte/features/lesson/domain/repositories/i_lesson_content_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'build_lesson_use_case.g.dart';

@riverpod
BuildLessonUseCase buildLessonUseCase(Ref ref) => BuildLessonUseCase(
      contentRepository: ref.read(lessonContentRepositoryProvider),
      exerciseRepository: ref.read(exerciseRepositoryProvider),
      lessonRepository: ref.read(lessonRepositoryProvider),
      userProgressRepository: ref.read(userProgressRepositoryProvider),
    );

// ── Domain-объект результата ─────────────────────────────────────────────────

class LessonData {
  final LessonModel lesson;

  /// Упорядоченная последовательность шагов.
  /// Индекс шага в этом списке = значение lastParagraph в Firestore.
  final List<LessonStep> steps;

  /// Доступны всегда, не входят в счётчик прогресса.
  final List<AdditionalModel> additional;

  /// null = текущий урок последний в курсе.
  final LessonModel? nextLesson;

  /// Количество уже завершённых шагов при открытии экрана (= lastParagraph).
  final int initialProgressIndex;

  const LessonData({
    required this.lesson,
    required this.steps,
    required this.additional,
    required this.nextLesson,
    required this.initialProgressIndex,
  });
}

// ── UseCase ──────────────────────────────────────────────────────────────────

class BuildLessonUseCase {
  final ILessonContentRepository contentRepository;
  final IExerciseRepository exerciseRepository;
  final ILessonRepository lessonRepository;
  final IUserProgressRepository userProgressRepository;

  const BuildLessonUseCase({
    required this.contentRepository,
    required this.exerciseRepository,
    required this.lessonRepository,
    required this.userProgressRepository,
  });

  Future<LessonData> execute(
    String userId,
    String langId,
    String lessonId,
  ) async {
    // Параллельно загружаем список всех уроков и прогресс пользователя
    final (lessons, progress) = await (
      lessonRepository.getLessons(langId),
      userProgressRepository.getUserLanguageProgress(userId, langId),
    ).wait;

    final lesson = lessons.firstWhere(
      (l) => l.id == lessonId,
      orElse: () => throw const NotFoundError(),
    );
    final currentIndex = lessons.indexOf(lesson);
    final nextLesson =
        currentIndex + 1 < lessons.length ? lessons[currentIndex + 1] : null;

    // Параллельно загружаем весь контент и упражнения урока
    final courseId = 'basic_$langId';
    final (theory, lexicalSets, verbs, additional, allExercises) = await (
      contentRepository.getTheory(langId, lessonId),
      contentRepository.getLexicalSets(langId, lessonId),
      contentRepository.getVerbs(langId, lessonId),
      contentRepository.getAdditional(langId, lessonId),
      exerciseRepository.getExercisesForLesson(courseId, lesson.lId),
    ).wait;

    // Группировка упражнений по типу
    final theoryExByBlockId = _groupTheoryExercises(allExercises);
    final vocabExercises = allExercises
        .where((e) => e.segmentType == 'vocab')
        .toList();
    final verbExercises = allExercises
        .where((e) => e.segmentType == 'verb')
        .toList();

    // Сборка детерминированной последовательности шагов
    final steps = <LessonStep>[
      for (final t in theory)
        TheoryLessonStep(
          theory: t,
          exercises: theoryExByBlockId[t.thId] ?? [],
        ),
      if (lexicalSets.isNotEmpty)
        LexicalLessonStep(sets: lexicalSets, exercises: vocabExercises),
      if (verbs.isNotEmpty)
        VerbsLessonStep(verbs: verbs, exercises: verbExercises),
    ];

    // lastParagraph осмыслен только для текущего урока (progress.lastLesson).
    // При открытии любого другого урока прохождение шагов начинается с нуля.
    final initialProgressIndex =
        progress?.lastLesson == lessonId ? progress!.lastParagraph : 0;

    return LessonData(
      lesson: lesson,
      steps: steps,
      additional: additional,
      nextLesson: nextLesson,
      initialProgressIndex: initialProgressIndex,
    );
  }

  /// Группирует theory-упражнения по linked_item_id (= th_id блока теории).
  Map<int, List<ExerciseModel>> _groupTheoryExercises(
    List<ExerciseModel> exercises,
  ) {
    final result = <int, List<ExerciseModel>>{};
    for (final ex in exercises) {
      if (ex.segmentType != 'theory') continue;
      final key = ex.linkedItemId ?? 0;
      result.putIfAbsent(key, () => []).add(ex);
    }
    return result;
  }
}
