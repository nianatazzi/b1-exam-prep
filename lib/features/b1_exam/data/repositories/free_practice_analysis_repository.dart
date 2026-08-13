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
      final result = await callable.call<Map<Object?, Object?>>({
        'transcript': transcript,
        'uiLanguage': uiLanguage,
      });
      return FreePracticeAnalysisModel.fromJson(_deepStringKeyedMap(result.data));
    } on FirebaseFunctionsException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}

// На Android cloud_functions отдаёт вложенные map/list как Map<Object?, Object?> —
// поверхностный Map<String, dynamic>.from() чинит только верхний уровень, а
// misusedWords[i] as Map<String, dynamic> внутри generated fromJson падает с
// TypeError на непустом списке. Рекурсивно приводим все вложенные map к
// Map<String, dynamic> перед парсингом.
Map<String, dynamic> _deepStringKeyedMap(Map<Object?, Object?> map) =>
    map.map((key, value) => MapEntry(key.toString(), _deepConvert(value)));

dynamic _deepConvert(dynamic value) {
  if (value is Map) {
    return _deepStringKeyedMap(Map<Object?, Object?>.from(value));
  }
  if (value is List) {
    return value.map(_deepConvert).toList();
  }
  return value;
}
