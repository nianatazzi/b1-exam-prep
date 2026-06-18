import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguobyte/core/locale/locale_provider.dart';
import 'package:linguobyte/core/logger/provider_observer.dart';
import 'package:linguobyte/core/router/app_router.dart';
import 'package:linguobyte/core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
