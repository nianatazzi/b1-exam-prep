import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/profile/domain/private_user_model.dart';
import 'package:linguobyte/features/profile/domain/public_user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance);
}

class UserRepository {
  final FirebaseFirestore _firestore;

  const UserRepository(this._firestore);

  Future<PublicUserModel> getPublicProfile(String userId) async {
    try {
      final doc = await _firestore.doc(FirestorePaths.publicUser(userId)).get();
      if (!doc.exists || doc.data() == null) throw const NotFoundError();
      return PublicUserModel.fromJson({'id': doc.id, ...doc.data()!});
    } on AppError {
      rethrow;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  Future<PrivateUserModel> getPrivateProfile(String userId) async {
    try {
      final doc =
          await _firestore.doc(FirestorePaths.privateUser(userId)).get();
      if (!doc.exists || doc.data() == null) throw const NotFoundError();
      final data = _preprocessPrivateData(doc.data()!);
      return PrivateUserModel.fromJson({'id': doc.id, ...data});
    } on AppError {
      rethrow;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  Future<void> updatePublicProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.doc(FirestorePaths.publicUser(userId)).update(data);
    } on AppError {
      rethrow;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  /// Создаёт документ языка с начальными значениями прогресса.
  /// SetOptions(merge: true) гарантирует, что существующий прогресс не сбрасывается.
  Future<void> updateLearningLanguage(String userId, String langId) async {
    try {
      await _firestore
          .doc(FirestorePaths.userLanguage(userId, langId))
          .set(
            {
              'lastLesson': '',
              'lastParagraph': 0,
              'oral_progress': 0,
              'grammar_progress': 0,
              'lexicon_progress': 0,
              'progress': <String, dynamic>{},
            },
            SetOptions(merge: true),
          );
    } on AppError {
      rethrow;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  /// Конвертирует Firestore Timestamp → ISO строку, чтобы domain-модель
  /// не зависела от cloud_firestore.
  Map<String, dynamic> _preprocessPrivateData(Map<String, dynamic> data) {
    final result = Map<String, dynamic>.from(data);
    final subscription = result['subscription'];
    if (subscription is Map<String, dynamic>) {
      final expiresAt = subscription['expiresAt'];
      if (expiresAt is Timestamp) {
        result['subscription'] = {
          ...subscription,
          'expiresAt': expiresAt.toDate().toIso8601String(),
        };
      }
    }
    return result;
  }
}
