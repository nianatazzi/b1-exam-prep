// Тест волны 2 (2-II): CompleteStepUseCase — оркестрация завершения шага.
import 'package:flutter_test/flutter_test.dart';
import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/home/domain/repositories/i_user_progress_repository.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/domain/models/theory_model.dart';
import 'package:linguobyte/features/lesson/domain/usecases/build_lesson_use_case.dart';
import 'package:linguobyte/features/lesson/domain/usecases/complete_step_use_case.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';
import 'package:linguobyte/features/profile/domain/repositories/i_streak_repository.dart';

class _SpyProgressRepo implements IUserProgressRepository {
  final UserLanguageProgressModel? progress;
  final List<String> savedStepKeys = [];
  final List<AchievementType> savedAchievements = [];
  StepResultModel? lastSavedResult;
  String? lastLessonWritten;
  int? lastParagraphWritten;

  _SpyProgressRepo({this.progress});

  @override
  Future<UserLanguageProgressModel?> getUserLanguageProgress(
          String userId, String langId) async =>
      progress;

  @override
  Future<void> updateProgress(
      String userId, String langId, String lastLesson, int lastParagraph) async {
    lastLessonWritten = lastLesson;
    lastParagraphWritten = lastParagraph;
  }

  @override
  Future<void> saveStepResult({
    required String userId,
    required String langId,
    required String stepKey,
    required StepResultModel result,
    required List<ExerciseResult> exerciseResults,
  }) async {
    savedStepKeys.add(stepKey);
    lastSavedResult = result;
  }

  @override
  Future<void> updateAchievement({
    required String userId,
    required String langId,
    required AchievementType type,
    required int newLevel,
  }) async {
    savedAchievements.add(type);
  }
}

class _FakeStreak implements IStreakRepository {
  final int streak;
  _FakeStreak(this.streak);
  @override
  Future<int> updateStreak(String userId) async => streak;
}

ExerciseResult _correct() => const ExerciseResult(
      exerciseId: 'e1',
      isCorrect: true,
      grammarTypes: ['vocabulary'],
      userAnswer: '',
      correctAnswer: '',
    );

TheoryLessonStep _theoryStep(int thId) => TheoryLessonStep(
      theory: TheoryModel(
          id: 't$thId', thId: thId, topic: 'T', title: 'T', text: ''),
      exercises: const [],
    );

LessonData _data({
  required int lId,
  required List<LessonStep> steps,
  LessonModel? nextLesson,
}) =>
    LessonData(
      lesson: LessonModel(id: 'lesson_0$lId', lId: lId, theme: 'X'),
      steps: steps,
      additional: const [],
      nextLesson: nextLesson,
      initialProgressIndex: 0,
    );

void main() {
  test('theory-шаг: сохраняет результат под ключом и двигает прогресс', () async {
    final repo = _SpyProgressRepo();
    final useCase = CompleteStepUseCase(
        progressRepository: repo, streakRepository: _FakeStreak(1));
    final step = _theoryStep(1);

    final outcome = await useCase.execute(
      userId: 'u',
      langId: 'fr',
      data: _data(lId: 3, steps: [step, _theoryStep(2)]),
      progressIndex: 0,
      currentStep: step,
      exerciseResults: [_correct()],
    );

    expect(repo.savedStepKeys, ['3_theory_1']);
    expect(outcome.newProgressIndex, 1);
    expect(repo.lastParagraphWritten, 1);
  });

  test('first_step выдаётся при завершении урока 1', () async {
    final repo = _SpyProgressRepo(
        progress: const UserLanguageProgressModel(id: 'fr', lastParagraph: 0));
    final useCase = CompleteStepUseCase(
        progressRepository: repo, streakRepository: _FakeStreak(1));
    final step = _theoryStep(1);

    await useCase.execute(
      userId: 'u',
      langId: 'fr',
      data: _data(lId: 1, steps: [step]), // один шаг → урок завершается
      progressIndex: 0,
      currentStep: step,
      exerciseResults: [_correct()],
    );

    expect(repo.savedAchievements, contains(AchievementType.firstStep));
  });

  test('завершение урока с nextLesson → прогресс переходит на next, lastParagraph=0',
      () async {
    final repo = _SpyProgressRepo();
    final useCase = CompleteStepUseCase(
        progressRepository: repo, streakRepository: _FakeStreak(1));
    final step = _theoryStep(1);

    await useCase.execute(
      userId: 'u',
      langId: 'fr',
      data: _data(
        lId: 1,
        steps: [step],
        nextLesson: const LessonModel(id: 'lesson_02', lId: 2, theme: 'B'),
      ),
      progressIndex: 0,
      currentStep: step,
      exerciseResults: [_correct()],
    );

    expect(repo.lastLessonWritten, 'lesson_02');
    expect(repo.lastParagraphWritten, 0);
  });

  test('saveSubStepResult сохраняет под переданным verb-ключом', () async {
    final repo = _SpyProgressRepo();
    final useCase = CompleteStepUseCase(
        progressRepository: repo, streakRepository: _FakeStreak(1));

    await useCase.saveSubStepResult(
      userId: 'u',
      langId: 'fr',
      stepKey: '4_verb_2',
      exerciseResults: [_correct()],
    );

    expect(repo.savedStepKeys, ['4_verb_2']);
  });

  test('глагол без упражнений + persistEmpty=true → пишет stepResult total=0',
      () async {
    final repo = _SpyProgressRepo();
    final useCase = CompleteStepUseCase(
        progressRepository: repo, streakRepository: _FakeStreak(1));

    await useCase.saveSubStepResult(
      userId: 'u',
      langId: 'fr',
      stepKey: '4_verb_1',
      exerciseResults: const [],
      persistEmpty: true,
    );

    expect(repo.savedStepKeys, ['4_verb_1']);
    expect(repo.lastSavedResult?.total, 0);
  });

  test('пустой субпарт без persistEmpty → ничего не пишет (не засоряет map)',
      () async {
    final repo = _SpyProgressRepo();
    final useCase = CompleteStepUseCase(
        progressRepository: repo, streakRepository: _FakeStreak(1));

    await useCase.saveSubStepResult(
      userId: 'u',
      langId: 'fr',
      stepKey: '1_theory_1',
      exerciseResults: const [],
    );

    expect(repo.savedStepKeys, isEmpty);
  });
}
