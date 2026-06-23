// Страховочная сетка (волна 0): фиксирует текущую корректную логику выдачи
// достижений. Рефакторинг волн 1/2/4 не должен её изменить (кроме master_conjugator,
// который в волне 1 начнёт реально срабатывать — на это будет отдельный тест).
import 'package:flutter_test/flutter_test.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/domain/models/theory_model.dart';
import 'package:linguobyte/features/lesson/domain/models/verb_model.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';
import 'package:linguobyte/features/profile/domain/usecases/check_achievement_use_case.dart';

ExerciseResult _res({required bool correct, String id = 'e1'}) => ExerciseResult(
      exerciseId: id,
      isCorrect: correct,
      grammarTypes: const ['vocabulary'],
      userAnswer: '',
      correctAnswer: '',
    );

TheoryLessonStep _theoryStep() => TheoryLessonStep(
      theory: const TheoryModel(
        id: 't1',
        thId: 1,
        topic: 'topic',
        title: 'title',
        text: 'text',
        duration: 1,
        reward: 0,
      ),
      exercises: const [],
    );

VerbsLessonStep _verbsStep(List<int> vIds) => VerbsLessonStep(
      verbSubSteps: [
        for (final vId in vIds)
          VerbSubStep(
            verb: VerbModel(
              id: 'v$vId',
              vId: vId,
              title: 'verb',
              type: 'regular',
              conjugation: const {},
              translation: const {},
              transcription: const {},
            ),
            exercises: const [],
          ),
      ],
    );

void main() {
  final useCase = CheckAchievementUseCase();

  group('first_step', () {
    test('выдаётся при завершении урока 1', () {
      final updates = useCase.check(
        segmentType: 'theory',
        lessonLId: 1,
        exerciseResults: const [],
        allStepResults: const {},
        currentAchievements: const {},
        lessonSteps: [_theoryStep()],
        isLessonComplete: true,
        currentStreak: 0,
      );
      expect(
        updates.where((u) => u.type == AchievementType.firstStep),
        isNotEmpty,
      );
    });

    test('не выдаётся повторно, если уровень уже >= 1', () {
      final updates = useCase.check(
        segmentType: 'theory',
        lessonLId: 1,
        exerciseResults: const [],
        allStepResults: const {},
        currentAchievements: {
          'first_step': const AchievementModel(
              type: AchievementType.firstStep, level: 1),
        },
        lessonSteps: [_theoryStep()],
        isLessonComplete: true,
        currentStreak: 0,
      );
      expect(
        updates.where((u) => u.type == AchievementType.firstStep),
        isEmpty,
      );
    });

    test('не выдаётся для урока != 1', () {
      final updates = useCase.check(
        segmentType: 'theory',
        lessonLId: 2,
        exerciseResults: const [],
        allStepResults: const {},
        currentAchievements: const {},
        lessonSteps: [_theoryStep()],
        isLessonComplete: true,
        currentStreak: 0,
      );
      expect(updates, isEmpty);
    });
  });

  group('focused_learner', () {
    test('выдаётся на 7-дневном стрике (уровень 1)', () {
      final updates = useCase.check(
        segmentType: 'theory',
        lessonLId: 5,
        exerciseResults: const [],
        allStepResults: const {},
        currentAchievements: const {},
        lessonSteps: [_theoryStep()],
        isLessonComplete: false,
        currentStreak: 7,
      );
      final focused =
          updates.where((u) => u.type == AchievementType.focusedLearner);
      expect(focused, isNotEmpty);
      expect(focused.first.newLevel, 1);
    });

    test('не выдаётся при стрике < 7', () {
      final updates = useCase.check(
        segmentType: 'theory',
        lessonLId: 5,
        exerciseResults: const [],
        allStepResults: const {},
        currentAchievements: const {},
        lessonSteps: [_theoryStep()],
        isLessonComplete: false,
        currentStreak: 6,
      );
      expect(updates, isEmpty);
    });
  });

  group('vocabulary_master', () {
    test('выдаётся, когда все vocab-упражнения верны', () {
      final updates = useCase.check(
        segmentType: 'vocab',
        lessonLId: 3,
        exerciseResults: [_res(correct: true), _res(correct: true, id: 'e2')],
        allStepResults: const {},
        currentAchievements: const {},
        lessonSteps: const [],
        isLessonComplete: false,
        currentStreak: 0,
      );
      expect(
        updates.where((u) => u.type == AchievementType.vocabularyMaster),
        isNotEmpty,
      );
    });

    test('не выдаётся при ошибке', () {
      final updates = useCase.check(
        segmentType: 'vocab',
        lessonLId: 3,
        exerciseResults: [_res(correct: true), _res(correct: false, id: 'e2')],
        allStepResults: const {},
        currentAchievements: const {},
        lessonSteps: const [],
        isLessonComplete: false,
        currentStreak: 0,
      );
      expect(updates, isEmpty);
    });
  });

  group('master_conjugator (текущее поведение: зависит от stepResults)', () {
    test('выдаётся, когда все verb-субшаги отмечены в stepResults', () {
      final updates = useCase.check(
        segmentType: 'verb',
        lessonLId: 4,
        exerciseResults: const [],
        allStepResults: {
          '4_verb_1': const StepResultModel(correct: 1, total: 1),
          '4_verb_2': const StepResultModel(correct: 1, total: 1),
        },
        currentAchievements: const {},
        lessonSteps: [_verbsStep([1, 2])],
        isLessonComplete: false,
        currentStreak: 0,
      );
      expect(
        updates.where((u) => u.type == AchievementType.masterConjugator),
        isNotEmpty,
      );
    });

    test('не выдаётся, если не все глаголы отмечены', () {
      final updates = useCase.check(
        segmentType: 'verb',
        lessonLId: 4,
        exerciseResults: const [],
        allStepResults: {
          '4_verb_1': const StepResultModel(correct: 1, total: 1),
        },
        currentAchievements: const {},
        lessonSteps: [_verbsStep([1, 2])],
        isLessonComplete: false,
        currentStreak: 0,
      );
      expect(updates, isEmpty);
    });
  });
}
