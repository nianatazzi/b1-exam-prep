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
      // Документ может отсутствовать при гонке на регистрации или ручном удалении.
      // Возвращаем пустую модель — экран должен отобразиться, а не упасть.
      if (!doc.exists || doc.data() == null) {
        return PublicUserModel(
          id: userId,
          name: '',
          surname: '',
          avatar: null,
          points: 0,
          preference: {},
        );
      }
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
      // Документ может отсутствовать если пользователь удалил его вручную.
      // Возвращаем дефолтную модель чтобы ProfileScreen не крашился.
      if (!doc.exists || doc.data() == null) {
        return PrivateUserModel(
          id: userId,
          deviceId: '',
          email: '',
          phone: '',
          subscription: const SubscriptionModel(plan: SubscriptionPlan.free),
          currentStreak: 0,
          bestStreak: 0,
          lastActiveDate: null,
        );
      }
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
      await _updateOrCreate(userId, data);
    } on AppError {
      rethrow;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  Future<void> saveSelectedLanguage(String userId, String langId) async {
    try {
      await _updateOrCreate(userId, {'preference.selectedLanguage': langId});
    } on AppError {
      rethrow;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  /// Выполняет update() документа public_user_info.
  /// Если документа не существует — создаёт его с дефолтами и повторяет update().
  /// Нужно для гонки на регистрации: Firebase Auth stream стреляет до того,
  /// как _createUserDocuments завершит batch-запись.
  Future<void> _updateOrCreate(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final ref = _firestore.doc(FirestorePaths.publicUser(userId));
    try {
      await ref.update(data);
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        await ref.set({
          'name': '',
          'surname': '',
          'avatar': null,
          'points': 0,
          'preference': <String, dynamic>{},
        });
        await ref.update(data);
      } else {
        throw mapFirebaseException(e);
      }
    }
  }

  Future<String?> getSelectedLanguage(String userId) async {
    try {
      final doc = await _firestore.doc(FirestorePaths.publicUser(userId)).get();
      if (!doc.exists || doc.data() == null) return null;
      final preference = doc.data()!['preference'];
      if (preference is! Map) return null;
      return preference['selectedLanguage'] as String?;
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
              'stats': {
                'grammar': {'correct': 0, 'total': 0},
                'vocabulary': {'correct': 0, 'total': 0},
                'listening': {'correct': 0, 'total': 0},
                'speaking': {'correct': 0, 'total': 0},
              },
              'stepResults': <String, dynamic>{},
              'achievements': <String, dynamic>{},
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
    final lastActive = result['lastActiveDate'];
    if (lastActive is Timestamp) {
      result['lastActiveDate'] = lastActive.toDate().toIso8601String();
    }
    return result;
  }
}
