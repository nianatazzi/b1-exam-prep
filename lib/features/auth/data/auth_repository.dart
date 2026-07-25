import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:b1_exam_prep/core/constants/firestore_paths.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/features/auth/domain/user_model.dart';
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
  ///
  /// При первом событии вызывает `reload()` чтобы проверить валидность
  /// кэшированной сессии на сервере. Это обнаруживает случай когда аккаунт
  /// был удалён через Firebase Console пока токен ещё не истёк.
  Stream<UserModel?> authStateChanges() {
    var isFirstEvent = true;
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        isFirstEvent = false;
        return null;
      }
      if (isFirstEvent) {
        isFirstEvent = false;
        try {
          await user.reload();
        } on FirebaseAuthException {
          // Аккаунт удалён или заблокирован — Firebase сбросит сессию,
          // stream пришлёт null следующим событием.
          return null;
        } catch (_) {
          // Сетевая ошибка — не ломаем offline, используем кэш.
        }
      }
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;
      return UserModel(
        id: currentUser.uid,
        email: currentUser.email ?? '',
        displayName: currentUser.displayName,
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
        'onboardingComplete': false,
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
      // Сбрасываем кэш Google-сессии, иначе следующий вход через Google
      // молча использует тот же аккаунт без диалога выбора.
      // Ошибку самого Google-выхода глушим — критичен только выход из Firebase.
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    }
  }

  /// Возвращает null если пользователь закрыл диалог Google без выбора аккаунта.
  Future<UserModel?> signInWithGoogle() async {
    try {
      final account = await _pickGoogleAccount();
      if (account == null) return null;

      final googleAuth = account.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        // idToken отсутствует: скорее всего не передан serverClientId
        throw const UnknownError(
          'Google idToken is null — убедитесь что GOOGLE_SERVER_CLIENT_ID передан через --dart-define',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _auth.signInWithCredential(credential);

      final isNew = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNew) {
        await _createUserDocuments(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
        );
      }

      return _userFromFirebase(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } on AppError {
      rethrow;
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  /// Показывает диалог выбора Google-аккаунта.
  /// Возвращает null если пользователь отменил.
  Future<GoogleSignInAccount?> _pickGoogleAccount() async {
    final googleSignIn = GoogleSignIn.instance;

    if (!googleSignIn.supportsAuthenticate()) {
      throw const UnknownError('Google Sign-In не поддерживается на этой платформе');
    }

    final completer = Completer<GoogleSignInAccount?>();
    late StreamSubscription<GoogleSignInAuthenticationEvent> sub;

    sub = googleSignIn.authenticationEvents.listen(
      (event) {
        if (completer.isCompleted) return;
        switch (event) {
          case GoogleSignInAuthenticationEventSignIn(:final user):
            completer.complete(user);
          case GoogleSignInAuthenticationEventSignOut():
            completer.complete(null);
        }
        sub.cancel();
      },
      onError: (Object e, StackTrace st) {
        if (!completer.isCompleted) completer.completeError(e, st);
        sub.cancel();
      },
    );

    try {
      await googleSignIn.authenticate();
    } catch (_) {
      // Пользователь отменил picker или произошла ошибка на уровне Google Sign-In
      sub.cancel();
      if (!completer.isCompleted) completer.complete(null);
      return null;
    }

    // На Android событие приходит ПОСЛЕ возврата authenticate() — ждём его.
    // Таймаут на случай если событие не придёт вовсе.
    return completer.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        sub.cancel();
        return null;
      },
    );
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
