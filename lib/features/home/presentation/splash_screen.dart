import 'package:flutter/material.dart';

/// Заглушка пока GoRouter ждёт инициализации AuthNotifier.
/// Вся навигация — через redirect в app_router.dart.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
