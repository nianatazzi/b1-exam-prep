import 'package:firebase_core/firebase_core.dart';

sealed class AppError {
  const AppError();
}

class NetworkError extends AppError {
  const NetworkError();
}

class AuthError extends AppError {
  const AuthError();
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
    'not-found' => const NotFoundError(),
    'permission-denied' || 'unauthenticated' => const AuthError(),
    // Сетевые и инфраструктурные сбои со стороны Firebase
    'unavailable' ||
    'deadline-exceeded' ||
    'network-request-failed' ||
    'cancelled' =>
      const NetworkError(),
    _ => UnknownError(e.message ?? e.code),
  };
}
