import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/features/home/domain/repositories/i_lesson_repository.dart';
import 'package:linguobyte/shared/models/lesson_step_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_repository.g.dart';

@riverpod
LessonRepository lessonRepository(Ref ref) =>
    LessonRepository(FirebaseFirestore.instance);

class LessonRepository implements ILessonRepository {
  final FirebaseFirestore _firestore;

  const LessonRepository(this._firestore);

  @override
  Future<List<LessonModel>> getLessons(String langId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.lessons(langId))
          .orderBy('l_id')
          .get();
      return snapshot.docs
          .map((doc) => LessonModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<LessonStepSummary>> getLessonStepSummaries(
    String langId,
    String lessonId,
    int lessonLId,
  ) async {
    try {
      // Параллельно: theory (полный список) + lexical limit(1) + verbs limit(1)
      // + проверка наличия final-упражнений (limit 1). Порядок шагов совпадает
      // с BuildLessonUseCase: theory[] → lexical? → verbs? → final?
      final (theorySnap, lexicalSnap, verbsSnap, finalSnap) = await (
        _firestore
            .collection(FirestorePaths.theory(langId, lessonId))
            .orderBy('th_id')
            .get(),
        _firestore
            .collection(FirestorePaths.lexicalSet(langId, lessonId))
            .limit(1)
            .get(),
        _firestore
            .collection(FirestorePaths.verbs(langId, lessonId))
            .limit(1)
            .get(),
        _firestore
            .collection(FirestorePaths.exercises)
            .where('course_id', isEqualTo: 'basic_$langId')
            .where('lesson_id', isEqualTo: lessonLId)
            .where('segment_type', isEqualTo: 'final')
            .limit(1)
            .get(),
      ).wait;

      final summaries = <LessonStepSummary>[];

      for (final doc in theorySnap.docs) {
        summaries.add(LessonStepSummary(
          type: LessonStepType.theory,
          title: doc.data()['topic'] as String? ?? '',
        ));
      }

      if (lexicalSnap.docs.isNotEmpty) {
        final setTitle =
            lexicalSnap.docs.first.data()['set_title'] as String? ?? '';
        summaries.add(
          LessonStepSummary(type: LessonStepType.lexical, title: setTitle),
        );
      }

      if (verbsSnap.docs.isNotEmpty) {
        summaries.add(
          const LessonStepSummary(type: LessonStepType.verbs, title: ''),
        );
      }

      if (finalSnap.docs.isNotEmpty) {
        summaries.add(
          const LessonStepSummary(type: LessonStepType.finalStep, title: ''),
        );
      }

      return summaries;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
