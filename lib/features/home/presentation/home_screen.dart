import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

// Заглушка до реализации полноценного HomeScreen в Фазе 3.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.push(AppRoutes.profile),
          child: Text(l10n.profileTitle),
        ),
      ),
    );
  }
}
