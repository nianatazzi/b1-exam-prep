import 'package:cloud_functions/cloud_functions.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/core/utils/cloud_functions_json.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_message_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_turn_result_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_dialogue_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dialogue_repository.g.dart';

@riverpod
DialogueRepository dialogueRepository(Ref ref) =>
    DialogueRepository(FirebaseFunctions.instance);

class DialogueRepository implements IDialogueRepository {
  final FirebaseFunctions _functions;

  const DialogueRepository(this._functions);

  @override
  Future<DialogueTurnResultModel> continueDialogue({
    required String langId,
    required String lessonId,
    required List<DialogueMessageModel> turns,
    required String uiLanguage,
  }) async {
    try {
      final callable = _functions.httpsCallable(
        'continueDialogue',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 65)),
      );
      final result = await callable.call<Map<Object?, Object?>>({
        'langId': langId,
        'lessonId': lessonId,
        'turns': turns.map((t) => t.toJson()).toList(),
        'uiLanguage': uiLanguage,
      });
      return DialogueTurnResultModel.fromJson(deepStringKeyedMap(result.data));
    } on FirebaseFunctionsException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
