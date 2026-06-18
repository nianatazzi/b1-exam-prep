import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Печатает ошибки любых провайдеров в консоль Run.
/// Подключается только в debug (см. main.dart) — в release не используется.
final class LoggingProviderObserver extends ProviderObserver {
  const LoggingProviderObserver();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final name =
        context.provider.name ?? context.provider.runtimeType.toString();
    debugPrint('⛔ [$name] $error\n$stackTrace');
  }
}
