// Страховочная сетка (волна 0): фиксирует сборку последовательности шагов урока
// (theory[] → lexical? → verbs? → final?), группировку упражнений и
// initialProgressIndex. Волна 2 переписывает модель шага — порядок и группировка
// должны сохраниться.
import 'package:flutter_test/flutter_test.dart';
import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/home/domain/repositories/i_lesson_repository.dart';
import 'package:linguobyte/features/home/domain/repositories/i_user_progress_repository.dart';
import 'package:linguobyte/features/lesson/domain/models/additional_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/domain/models/lexical_set_model.dart';
import 'package:linguobyte/features/lesson/domain/models/theory_model.dart';
import 'package:linguobyte/features/lesson/domain/models/verb_model.dart';
import 'package:linguobyte/features/lesson/domain/repositories/i_exercise_repository.dart';
import 'package:linguobyte/features/lesson/domain/repositories/i_lesson_content_repository.dart';
import 'package:linguobyte/features/lesson/domain/usecases/build_lesson_use_case.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';
import 'package:linguobyte/shared/models/lesson_step_summary.dart';

// ── Fake-репозитории ──────────────────────────────────────────────────────────

class _FakeLessonRepo implements ILessonRepository {
  @override
  Future<List<LessonModel>> getLessons(String langId) async => const [
        LessonModel(id: 'lesson_01', lId: 1, theme: 'A'),
        LessonModel(id: 'lesson_02', lId: 2, theme: 'B'),
      ];
  @override
  Future<List<LessonStepSummary>> getLessonStepSummaries(
          String langId, String lessonId, int lessonLId) async =>
      const [];
}

class _FakeProgressRepo implements IUserProgressRepository {
  @override
  Future<UserLanguageProgressModel?> getUserLanguageProgress(
          String userId, String langId) async =>
      const UserLanguageProgressModel(
          id: 'fr', lastLesson: 'lesson_01', lastParagraph: 2);
  @override
  Future<void> updateProgress(
      String userId, String langId, String lastLesson, int lastParagraph) async {}
  @override
  Future<void> saveStepResult({
    required String userId,
    required String langId,
    required String stepKey,
    required StepResultModel result,
    required List<ExerciseResult> exerciseResults,
  }) async {}
  @override
  Future<void> updateAchievement({
    required String userId,
    required String langId,
    required AchievementType type,
    required int newLevel,
  }) async {}
}

class _FakeContentRepo implements ILessonContentRepository {
  @override
  Future<List<TheoryModel>> getTheory(String langId, String lessonId) async =>
      const [
        TheoryModel(
            id: 't1', thId: 1, topic: 'T', title: 'T', text: '',
            duration: 1, reward: 0),
      ];
  @override
  Future<List<LexicalSetModel>> getLexicalSets(
          String langId, String lessonId) async =>
      const [
        LexicalSetModel(
            id: 'l1', vocId: 1, title: 'w', translation: 't',
            transcription: 'tr', setTitle: 'Set', reward: 0),
      ];
  @override
  Future<List<VerbModel>> getVerbs(String langId, String lessonId) async => const [
        VerbModel(id: 'v1', vId: 1, title: 'go', type: 'r',
            conjugation: {}, translation: {}, transcription: {}),
        VerbModel(id: 'v2', vId: 2, title: 'be', type: 'r',
            conjugation: {}, translation: {}, transcription: {}),
      ];
  @override
  Future<List<AdditionalModel>> getAdditional(
          String langId, String lessonId) async =>
      const [];
}

class _FakeExerciseRepo implements IExerciseRepository {
  @override
  Future<List<ExerciseModel>> getExercisesForLesson(
          String courseId, int lessonLId) async =>
      const [
        ExerciseModel(id: 'x1', exId: 1, type: 'fill_blank',
            segmentType: 'theory', linkedItemId: 1),
        ExerciseModel(id: 'x2', exId: 2, type: 'wordcard', segmentType: 'vocab'),
        ExerciseModel(id: 'x3', exId: 3, type: 'fill_blank',
            segmentType: 'verb', linkedItemId: 1),
        ExerciseModel(id: 'x4', exId: 4, type: 'fill_blank',
            segmentType: 'verb', linkedItemId: 2),
        ExerciseModel(id: 'x5', exId: 5, type: 'mosaic', segmentType: 'final'),
      ];
}

void main() {
  final useCase = BuildLessonUseCase(
    contentRepository: _FakeContentRepo(),
    exerciseRepository: _FakeExerciseRepo(),
    lessonRepository: _FakeLessonRepo(),
    userProgressRepository: _FakeProgressRepo(),
  );

  test('порядок шагов: theory → lexical → verbs → final', () async {
    final data = await useCase.execute('u', 'fr', 'lesson_01');
    expect(data.steps.map((s) => s.runtimeType).toList(), [
      TheoryLessonStep,
      LexicalLessonStep,
      VerbsLessonStep,
      FinalLessonStep,
    ]);
  });

  test('theory-упражнения сгруппированы по linked_item_id', () async {
    final data = await useCase.execute('u', 'fr', 'lesson_01');
    final theory = data.steps.whereType<TheoryLessonStep>().first;
    expect(theory.exercises.map((e) => e.exId), [1]);
  });

  test('verb-субшаги по vId, каждому свои упражнения', () async {
    final data = await useCase.execute('u', 'fr', 'lesson_01');
    final verbs = data.steps.whereType<VerbsLessonStep>().first;
    expect(verbs.verbSubSteps.map((s) => s.verb.vId), [1, 2]);
    expect(verbs.verbSubSteps[0].exercises.single.exId, 3);
    expect(verbs.verbSubSteps[1].exercises.single.exId, 4);
  });

  test('nextLesson и initialProgressIndex для текущего урока', () async {
    final data = await useCase.execute('u', 'fr', 'lesson_01');
    expect(data.nextLesson?.id, 'lesson_02');
    expect(data.initialProgressIndex, 2); // lastLesson == lesson_01 → lastParagraph
  });

  test('для другого урока прогресс начинается с нуля', () async {
    final data = await useCase.execute('u', 'fr', 'lesson_02');
    expect(data.initialProgressIndex, 0); // lastLesson != lesson_02
    expect(data.nextLesson, isNull); // последний урок
  });
}
