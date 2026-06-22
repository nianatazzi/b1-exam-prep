import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/home/domain/repositories/i_user_progress_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_progress_repository.g.dart';

@riverpod
UserProgressRepository userProgressRepository(Ref ref) =>
    UserProgressRepository(FirebaseFirestore.instance);

class UserProgressRepository implements IUserProgressRepository {
  final FirebaseFirestore _firestore;

  const UserProgressRepository(this._firestore);

  @override
  Future<UserLanguageProgressModel?> getUserLanguageProgress(
    String userId,
    String langId,
  ) async {
    try {
      final doc = await _firestore
          .doc(FirestorePaths.userLanguage(userId, langId))
          .get();
      if (!doc.exists || doc.data() == null) return null;
      final data = _preprocessProgressData(doc.data()!);
      return UserLanguageProgressModel.fromJson({...data, 'id': doc.id});
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<void> updateProgress(
    String userId,
    String langId,
    String lastLesson,
    int lastParagraph,
  ) async {
    try {
      // merge: true — документ языка создаётся при первом сохранении прогресса,
      // если его ещё нет (новый пользователь). Остальные поля прогресса не затираются.
      await _firestore.doc(FirestorePaths.userLanguage(userId, langId)).set(
        {
          'lastLesson': lastLesson,
          'lastParagraph': lastParagraph,
        },
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  /// Конвертирует Timestamp → ISO строку в stepResults и achievements.
  Map<String, dynamic> _preprocessProgressData(Map<String, dynamic> data) {
    final result = Map<String, dynamic>.from(data);

    final stepResults = result['stepResults'];
    if (stepResults is Map) {
      final converted = <String, dynamic>{};
      for (final entry in stepResults.entries) {
        if (entry.value is Map) {
          final step = Map<String, dynamic>.from(entry.value as Map);
          final completedAt = step['completedAt'];
          if (completedAt is Timestamp) {
            step['completedAt'] = completedAt.toDate().toIso8601String();
          }
          converted[entry.key as String] = step;
        }
      }
      result['stepResults'] = converted;
    }

    final achievements = result['achievements'];
    if (achievements is Map) {
      final converted = <String, dynamic>{};
      for (final entry in achievements.entries) {
        if (entry.value is Map) {
          final ach = Map<String, dynamic>.from(entry.value as Map);
          final updatedAt = ach['updatedAt'];
          if (updatedAt is Timestamp) {
            ach['updatedAt'] = updatedAt.toDate().toIso8601String();
          }
          converted[entry.key as String] = ach;
        }
      }
      result['achievements'] = converted;
    }

    return result;
  }
}
