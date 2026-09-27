import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/dialogue_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/lesson_content_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/calculate_speech_score.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_message_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_scenario_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/usecases/submit_dialogue_use_case.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/providers/oral_step_outcome.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dialogue_notifier.g.dart';

class DialogueState {
  final DialogueScenarioModel scenario;
  final List<DialogueMessageModel> turns;
  final bool isAwaitingReply;
  final int turnsLeft;
  final bool shouldClose;
  final bool isSubmitting;
  // Ошибка последнего хода (continueDialogue) — только для отображения,
  // не персистится. copyWith() не сохраняет её между вызовами (см. ниже) —
  // ошибка актуальна только до следующего изменения состояния.
  final AppError? error;

  const DialogueState({
    required this.scenario,
    required this.turns,
    this.isAwaitingReply = false,
    required this.turnsLeft,
    this.shouldClose = false,
    this.isSubmitting = false,
    this.error,
  });

  // error НЕ мёржится через "?? this.error" — любой вызов copyWith без
  // явного error: сбрасывает его. Ошибка хода одноразовая: как только
  // начался новый ход или завершение диалога, старая ошибка не актуальна.
  DialogueState copyWith({
    List<DialogueMessageModel>? turns,
    bool? isAwaitingReply,
    int? turnsLeft,
    bool? shouldClose,
    bool? isSubmitting,
    AppError? error,
  }) =>
      DialogueState(
        scenario: scenario,
        turns: turns ?? this.turns,
        isAwaitingReply: isAwaitingReply ?? this.isAwaitingReply,
        turnsLeft: turnsLeft ?? this.turnsLeft,
        shouldClose: shouldClose ?? this.shouldClose,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        error: error,
      );
}

/// Диалог урока (дизайн диалога, Lesson Matrix) — состояние хода хранится на
/// клиенте, continueDialogue вызывается заново на каждый ход с полной
/// историей (функция без состояния). STT здесь запускается и
/// останавливается на КАЖДЫЙ ход, а не работает непрерывно как в
/// FreePracticeView — микрофон включается только пока студент отвечает.
@riverpod
class DialogueNotifier extends _$DialogueNotifier {
  String get _userId => ref.read(authProvider).requireValue!.id;

  @override
  Future<DialogueState> build(String langId, String lessonId) async {
    final contentRepo = ref.read(lessonContentRepositoryProvider);
    final lesson = await contentRepo.getLesson(langId, lessonId);
    final scenario = lesson.dialogueTask;

    return DialogueState(
      scenario: scenario,
      turns: [
        DialogueMessageModel(
          role: DialogueRole.ai,
          text: scenario.openingLine,
        ),
      ],
      turnsLeft: scenario.maxTurns,
    );
  }

  Future<void> sendUserTurn(String text, String uiLanguage) async {
    final current = state.requireValue;
    if (current.isAwaitingReply || current.shouldClose || text.trim().isEmpty) {
      return;
    }

    final withUserTurn = [
      ...current.turns,
      DialogueMessageModel(role: DialogueRole.user, text: text),
    ];
    state = AsyncData(current.copyWith(turns: withUserTurn, isAwaitingReply: true));

    final repo = ref.read(dialogueRepositoryProvider);
    try {
      final result = await repo.continueDialogue(
        langId: langId,
        lessonId: lessonId,
        turns: withUserTurn,
        uiLanguage: uiLanguage,
      );

      state = AsyncData(current.copyWith(
        turns: [
          ...withUserTurn,
          DialogueMessageModel(role: DialogueRole.ai, text: result.reply),
        ],
        isAwaitingReply: false,
        turnsLeft: result.turnsLeft,
        shouldClose: result.shouldClose,
      ));
    } catch (e) {
      // Ход не дошёл до сервера — откатываем реплику студента из истории
      // (current, не withUserTurn), иначе она "зависает" в чате без ответа
      // и без возможности повторить попытку.
      state = AsyncData(current.copyWith(
        isAwaitingReply: false,
        error: e is AppError ? e : UnknownError(e.toString()),
      ));
    }
  }

  /// Финальная отправка — SubmitDialogueUseCase (анализ + сохранение),
  /// вызывается один раз при завершении диалога (shouldClose/max_turns).
  Future<OralStepOutcome> finish({
    required int durationSeconds,
    required String uiLanguage,
  }) async {
    final current = state.requireValue;
    state = AsyncData(current.copyWith(isSubmitting: true));

    final useCase = ref.read(submitDialogueUseCaseProvider);
    final analysis = await useCase.execute(
      userId: _userId,
      langId: langId,
      lessonId: lessonId,
      turns: current.turns,
      durationSeconds: durationSeconds,
      uiLanguage: uiLanguage,
    );

    state = AsyncData(current.copyWith(isSubmitting: false));

    return OralStepOutcome(
      score: analysis == null ? null : calculateSpeechScore(analysis),
      analysis: analysis,
    );
  }
}
