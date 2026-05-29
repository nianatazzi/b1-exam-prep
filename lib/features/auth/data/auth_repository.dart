import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/auth/domain/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
}

class AuthRepository {
  final FirebaseAuth _auth;
  // Временно здесь — см. технический долг в ARCHITECTURE.md
  final FirebaseFirestore _firestore;

  const AuthRepository(this._auth, this._firestore);

  /// Стрим состояния авторизации — null когда пользователь не вошёл.
  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      );
    });
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      try {
        await _createUserDocuments(uid: uid, email: email);
      } catch (_) {
        // Откат: удаляем Auth-аккаунт чтобы пользователь мог повторить
        // регистрацию. Без этого повтор вернёт email-already-in-use.
        try {
          await credential.user!.delete();
        } catch (_) {
          // Если удаление не удалось — аккаунт остаётся без документов.
          // Технический долг: решить через Cloud Functions (см. ARCHITECTURE.md).
        }
        rethrow;
      }
      return _userFromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  /// Создаёт документы профиля при регистрации.
  /// Временное решение — см. технический долг в ARCHITECTURE.md.
  Future<void> _createUserDocuments({
    required String uid,
    required String email,
  }) async {
    final batch = _firestore.batch();

    batch.set(
      _firestore.doc(FirestorePaths.publicUser(uid)),
      {
        'name': '',
        'surname': '',
        'avatar': null,
        'points': 0,
        'preference': <String, dynamic>{},
      },
    );

    batch.set(
      _firestore.doc(FirestorePaths.privateUser(uid)),
      {
        'deviceId': '',
        'email': email,
        'phone': '',
        'subscription': {'plan': 'free', 'expiresAt': null},
      },
    );

    await batch.commit();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    }
  }

  UserModel _userFromFirebase(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }
}
