import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_message_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_turn_result_model.dart';

abstract class IDialogueRepository {
  /// Вызывает Cloud Function continueDialogue — один ход диалога. Сценарий
  /// читается на сервере по [lessonId] (lesson.dialogue_task), не из
  /// payload — иначе системный промпт можно подменить с клиента (дизайн
  /// диалога, "Consequence to design for"). [turns] — вся история хода на
  /// данный момент, состояние диалога хранится на клиенте (DialogueNotifier),
  /// функция без состояния.
  Future<DialogueTurnResultModel> continueDialogue({
    required String langId,
    required String lessonId,
    required List<DialogueMessageModel> turns,
    required String uiLanguage,
  });
}
