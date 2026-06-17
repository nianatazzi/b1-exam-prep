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
      return UserLanguageProgressModel.fromJson({...doc.data()!, 'id': doc.id});
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
      await _firestore.doc(FirestorePaths.userLanguage(userId, langId)).update({
        'lastLesson': lastLesson,
        'lastParagraph': lastParagraph,
      });
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
