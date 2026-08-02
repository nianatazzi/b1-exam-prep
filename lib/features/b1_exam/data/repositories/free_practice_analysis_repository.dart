import 'package:cloud_functions/cloud_functions.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_free_practice_analysis_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'free_practice_analysis_repository.g.dart';

@riverpod
FreePracticeAnalysisRepository freePracticeAnalysisRepository(Ref ref) =>
    FreePracticeAnalysisRepository(FirebaseFunctions.instance);

class FreePracticeAnalysisRepository implements IFreePracticeAnalysisRepository {
  final FirebaseFunctions _functions;

  const FreePracticeAnalysisRepository(this._functions);

  @override
  Future<FreePracticeAnalysisModel> analyze({
    required String transcript,
    required String uiLanguage,
  }) async {
    try {
      final callable = _functions.httpsCallable('analyzeFreePractice');
      final result = await callable.call<Map<String, dynamic>>({
        'transcript': transcript,
        'uiLanguage': uiLanguage,
      });
      return FreePracticeAnalysisModel.fromJson(
        Map<String, dynamic>.from(result.data),
      );
    } on FirebaseFunctionsException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
