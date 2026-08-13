import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:b1_exam_prep/core/locale/locale_provider.dart';
import 'package:b1_exam_prep/core/logger/provider_observer.dart';
import 'package:b1_exam_prep/core/router/app_router.dart';
import 'package:b1_exam_prep/core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // На Android google-services.json уже регистрирует "[DEFAULT]" через нативный
  // FirebaseInitProvider до вызова main(). Проверка Firebase.apps.isEmpty ненадёжна —
  // на части устройств Dart-кэш ещё не синхронизирован с нативной стороной на этом
  // этапе, поэтому initializeApp() всё равно вызывается и падает с [core/duplicate-app].
  // Без обработки это необработанное исключение в main() — main() никогда не доходит
  // до runApp(), приложение зависает на splash-экране.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  // serverClientId нужен для получения idToken от Google (--dart-define=GOOGLE_SERVER_CLIENT_ID=...)
  const googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
  await GoogleSignIn.instance.initialize(
    serverClientId: googleServerClientId.isEmpty ? null : googleServerClientId,
  );

  // В debug-режиме показываем ошибки на экране; в release — отправляем в Crashlytics
  FlutterError.onError = (details) {
    if (kDebugMode) {
      FlutterError.presentError(details);
    } else {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  // Аналитика отключена в debug-режиме, события настраиваются позже
  await FirebaseAnalytics.instance
      .setAnalyticsCollectionEnabled(!kDebugMode);

  runApp(
    ProviderScope(
      observers: kDebugMode ? const [LoggingProviderObserver()] : const [],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(appLocaleProvider);
    return MaterialApp.router(
      routerConfig: router,
      locale: locale,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
