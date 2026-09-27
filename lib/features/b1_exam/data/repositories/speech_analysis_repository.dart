import 'package:cloud_functions/cloud_functions.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/core/utils/cloud_functions_json.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_speech_analysis_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'speech_analysis_repository.g.dart';

@riverpod
SpeechAnalysisRepository speechAnalysisRepository(Ref ref) =>
    SpeechAnalysisRepository(FirebaseFunctions.instance);

class SpeechAnalysisRepository implements ISpeechAnalysisRepository {
  final FirebaseFunctions _functions;

  const SpeechAnalysisRepository(this._functions);

  @override
  Future<SpeechAnalysisModel> analyze({
    required String langId,
    required String lessonId,
    required OralStep oralStep,
    required String transcript,
    required String uiLanguage,
  }) async {
    try {
      final callable = _functions.httpsCallable('analyzeSpeech');
      final result = await callable.call<Map<Object?, Object?>>({
        'langId': langId,
        'lessonId': lessonId,
        'oralStep': oralStep.name,
        'transcript': transcript,
        'uiLanguage': uiLanguage,
      });
      return SpeechAnalysisModel.fromJson(deepStringKeyedMap(result.data));
    } on FirebaseFunctionsException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
