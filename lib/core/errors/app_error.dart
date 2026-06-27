import 'package:firebase_core/firebase_core.dart';

sealed class AppError {
  const AppError();
}

class NetworkError extends AppError {
  const NetworkError();
}

enum AuthErrorCode {
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
  weakPassword,
  requiresRecentLogin,
}

class AuthError extends AppError {
  final AuthErrorCode? code;
  const AuthError([this.code]);
}

class NotFoundError extends AppError {
  const NotFoundError();
}

class UnknownError extends AppError {
  final String message;
  const UnknownError(this.message);
}

/// Маппит [FirebaseException] в [AppError].
/// Вызывается только в data-слое — до domain исключения не доходят.
AppError mapFirebaseException(FirebaseException e) {
  return switch (e.code) {
    'wrong-password' || 'invalid-credential' => const AuthError(AuthErrorCode.wrongPassword),
    'user-not-found' => const AuthError(AuthErrorCode.userNotFound),
    'email-already-in-use' => const AuthError(AuthErrorCode.emailAlreadyInUse),
    'weak-password' => const AuthError(AuthErrorCode.weakPassword),
    'requires-recent-login' => const AuthError(AuthErrorCode.requiresRecentLogin),
    'not-found' => const NotFoundError(),
    'permission-denied' || 'unauthenticated' => const AuthError(),
    'unavailable' ||
    'deadline-exceeded' ||
    'network-request-failed' ||
    'cancelled' =>
      const NetworkError(),
    _ => UnknownError(e.message ?? e.code),
  };
}
