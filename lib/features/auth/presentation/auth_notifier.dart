import 'dart:async';

import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/auth/data/auth_repository.dart';
import 'package:linguobyte/features/auth/domain/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

/// Глобальное состояние авторизации.
/// keepAlive — живёт всё время работы приложения, GoRouter зависит от него.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  /// Флаг новой регистрации — in-memory, не переживает перезапуск приложения.
  /// true → GoRouter ведёт на ProfileScreen для заполнения данных.
  /// Сбрасывается при signIn и signOut.
  /// Технический долг: заменить на onboardingComplete в Firestore (см. ARCHITECTURE.md).
  bool _isNewUser = false;
  bool get isNewUser => _isNewUser;

  @override
  Future<UserModel?> build() {
    final repo = ref.read(authRepositoryProvider);
    final completer = Completer<UserModel?>();

    // Подписываемся один раз: первое значение инициализирует провайдер,
    // последующие обновляют state напрямую.
    final sub = repo.authStateChanges().listen(
      (user) {
        if (!completer.isCompleted) {
          completer.complete(user);
        } else {
          state = AsyncData(user);
        }
      },
      onError: (Object e, StackTrace st) {
        final appError = e is AppError ? e : UnknownError(e.toString());
        if (!completer.isCompleted) {
          completer.completeError(appError, st);
        } else {
          state = AsyncError(appError, st);
        }
      },
    );

    ref.onDispose(sub.cancel);
    return completer.future;
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signIn(
            email: email,
            password: password,
          );
      // Возвращающийся пользователь — профиль уже заполнен
      _isNewUser = false;
      // Успех: authStateChanges обновит state через stream-подписку
    } on AppError catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncLoading();
    // Устанавливаем ДО await: Firebase Auth stream может сработать внутри
    // вызова и GoRouter вычислит redirect раньше чем мы вернёмся сюда.
    _isNewUser = true;
    try {
      await ref.read(authRepositoryProvider).signUp(
            email: email,
            password: password,
          );
    } on AppError catch (e, st) {
      _isNewUser = false;
      state = AsyncError(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).signInWithGoogle();
      if (user == null) {
        // Пользователь закрыл диалог Google — сбрасываем loading без ошибки
        state = const AsyncData(null);
      }
      // Успех: authStateChanges обновит state через stream-подписку.
      // _isNewUser остаётся false — auth stream может сработать внутри
      // repo-await до того как мы получим результат (см. ARCHITECTURE.md техдолг).
    } on AppError catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    _isNewUser = false;
    try {
      await ref.read(authRepositoryProvider).signOut();
      // Stream emit null → state = AsyncData(null) автоматически
    } on AppError catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// После успеха возвращаем state в AsyncData(null):
  /// пользователь остался неавторизован, stream не emit-ит.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }

  Future<void> resetPassword({required String email}) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).resetPassword(email: email);
      state = const AsyncData(null);
    } on AppError catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
