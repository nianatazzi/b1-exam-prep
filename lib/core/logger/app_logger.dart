import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  // В релизной сборке логи полностью отключены
  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.off : Level.trace,
    printer: PrettyPrinter(methodCount: 0),
  );

  static void d(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  static void i(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  static void w(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
