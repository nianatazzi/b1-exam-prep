import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b1_exam_prep/core/constants/app_sizes.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/core/locale/locale_provider.dart';
import 'package:b1_exam_prep/core/theme/app_colors.dart';
import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/profile/presentation/profile_notifier.dart';
import 'package:b1_exam_prep/features/profile/presentation/settings_notifier.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: l10n.interfaceLanguageSection),
            const SizedBox(height: AppSpacing.sm),
            const _LanguageTile(),
            const SizedBox(height: AppSpacing.x2l),
            _SectionHeader(title: l10n.appearanceSection),
            const SizedBox(height: AppSpacing.sm),
            const _AppearanceToggle(),
            const SizedBox(height: AppSpacing.x2l),
            _SectionHeader(title: l10n.speechSection),
            const SizedBox(height: AppSpacing.sm),
            const _SpeechSpeedSlider(),
            const SizedBox(height: AppSpacing.x2l),
            _SectionHeader(title: l10n.accountSection),
            const SizedBox(height: AppSpacing.sm),
            const _SignOutButton(),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
    );
  }
}

class _LanguageTile extends ConsumerWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final activeLocale = ref.watch(appLocaleProvider);
    final activeCode =
        activeLocale?.languageCode ??
        Localizations.localeOf(context).languageCode;

    final langName = switch (activeCode) {
      'ru' => l10n.langRussian,
      'fr' => l10n.langFrench,
      'es' => l10n.langSpanish,
      _ => l10n.langEnglish,
    };

    return _SettingsCard(
      child: ListTile(
        leading: Icon(Icons.language, color: colors.textSecondary),
        title: Text(l10n.languageLabel),
        subtitle: Text(langName),
        trailing: Icon(Icons.chevron_right, color: colors.textMuted),
        onTap: () => _showLanguagePicker(context, ref, activeCode),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    String activeCode,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final languages = [
      ('en', l10n.langEnglish),
      ('ru', l10n.langRussian),
      ('fr', l10n.langFrench),
      ('es', l10n.langSpanish),
    ];

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            final isSelected = activeCode == lang.$1;
            return ListTile(
              title: Text(lang.$2),
              trailing: isSelected
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                ref.read(settingsProvider.notifier).setUiLanguage(lang.$1);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _AppearanceToggle extends ConsumerWidget {
  const _AppearanceToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(profileProvider);
    final currentTheme = profileAsync.asData?.value.publicProfile
            .preference['theme'] as String? ??
        'dark';
    final isDark = currentTheme == 'dark';

    return _SettingsCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.appearanceLabel,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    isDark ? l10n.darkModeSubtitle : l10n.lightModeSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            _ThemeToggle(
              isDark: isDark,
              onChanged: (dark) {
                ref
                    .read(settingsProvider.notifier)
                    .setTheme(dark ? 'dark' : 'light');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _ThemeToggle({required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        color: Theme.of(context).extension<AppColors>()!.surfaceOverlay,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleChip(
            label: l10n.darkMode,
            isSelected: isDark,
            onTap: () => onChanged(true),
            scheme: scheme,
          ),
          _ToggleChip(
            label: l10n.lightMode,
            isSelected: !isDark,
            onTap: () => onChanged(false),
            scheme: scheme,
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _ToggleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          color: isSelected ? scheme.primary : Colors.transparent,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? scheme.onPrimary : scheme.onSurface,
              ),
        ),
      ),
    );
  }
}

class _SpeechSpeedSlider extends ConsumerStatefulWidget {
  const _SpeechSpeedSlider();

  @override
  ConsumerState<_SpeechSpeedSlider> createState() => _SpeechSpeedSliderState();
}

class _SpeechSpeedSliderState extends ConsumerState<_SpeechSpeedSlider> {
  double _speed = 1.0;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final profileAsync = ref.watch(profileProvider);

    if (!_initialized) {
      final savedSpeed = profileAsync.asData?.value.publicProfile
              .preference['speechSpeed'] as num?;
      if (savedSpeed != null) {
        _speed = savedSpeed.toDouble();
        _initialized = true;
      }
    }

    return _SettingsCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.volume_up, color: colors.textSecondary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.speechSpeedLabel,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${l10n.speechSpeedNormal} · ${_speed.toStringAsFixed(1)}×',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Slider(
              value: _speed,
              min: 0.5,
              max: 2.0,
              divisions: 6,
              onChanged: (v) => setState(() => _speed = v),
              onChangeEnd: (v) {
                ref.read(settingsProvider.notifier).setSpeechSpeed(v);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0.5×', style: Theme.of(context).textTheme.bodySmall),
                  Text('2.0×', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignOutButton extends ConsumerWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isSigningOut = ref.watch(authProvider).isLoading;

    return SizedBox(
      height: AppSizes.buttonHeight,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isSigningOut
            ? null
            : () => ref.read(authProvider.notifier).signOut(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          side: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        icon: isSigningOut
            ? SizedBox(
                width: AppSizes.iconMd,
                height: AppSizes.iconMd,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            : const Icon(Icons.logout),
        label: Text(l10n.signOut),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppColors>()!.surfaceRaised,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: child,
    );
  }
}
