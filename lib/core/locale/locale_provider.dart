import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

/// Хранит выбранную пользователем локаль интерфейса.
/// null → использовать системную локаль устройства.
/// keepAlive — живёт всё время работы приложения, MaterialApp зависит от него.
@Riverpod(keepAlive: true)
class AppLocaleNotifier extends _$AppLocaleNotifier {
  @override
  Locale? build() => null;

  void setLocale(Locale locale) => state = locale;
}
