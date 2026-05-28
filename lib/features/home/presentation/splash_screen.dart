import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // ref.watch перестраивает виджет при каждом изменении authProvider.
    // Когда auth определён (уже или после загрузки) — планируем навигацию.
    // addPostFrameCallback нужен, чтобы не вызывать context.go во время build.
    if (!authState.isLoading) {
      final isLoggedIn = authState.asData?.value != null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(isLoggedIn ? AppRoutes.home : AppRoutes.auth);
        }
      });
    }

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
