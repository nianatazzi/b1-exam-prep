import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/auth/presentation/onboarding_notifier.dart';
import 'package:linguobyte/features/home/domain/models/language_model.dart';
import 'package:linguobyte/l10n/app_localizations.dart';
import 'package:linguobyte/shared/widgets/avatar_picker_grid.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final userId = ref.read(authProvider).asData?.value?.id;
    if (userId == null) return;
    await ref.read(onboardingProvider.notifier).submit(userId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingProvider);
    final colors = Theme.of(context).extension<AppColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.x3l),

                Text(
                  l10n.onboardingTitle,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.onboardingSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: AppSpacing.x2l),

                Text(
                  l10n.onboardingChooseAvatar,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),

                AvatarPickerGrid(
                  selectedId: state.avatar,
                  onSelect: (id) =>
                      ref.read(onboardingProvider.notifier).setAvatar(id),
                ),

                const SizedBox(height: AppSpacing.x2l),

                Text(
                  l10n.onboardingChooseLanguage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),

                ref.watch(onboardingLanguagesProvider).when(
                  data: (languages) => _LanguagePicker(
                    languages: languages,
                    selectedId: state.selectedLanguage,
                    onSelect: (id) =>
                        ref.read(onboardingProvider.notifier).setLanguage(id),
                  ),
                  loading: () => const SizedBox(
                    height: AppSizes.buttonHeight,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                ),

                const SizedBox(height: AppSpacing.x2l),

                _OnboardingTextField(
                  controller: _nameCtrl,
                  label: '${l10n.nameLabel} *',
                  enabled: !state.isLoading,
                  colors: colors,
                  onChanged: (v) =>
                      ref.read(onboardingProvider.notifier).setName(v),
                  validator: (v) =>
                      (v?.trim().isEmpty ?? true) ? l10n.validationFieldRequired : null,
                ),

                const SizedBox(height: AppSpacing.md),

                _OnboardingTextField(
                  controller: _surnameCtrl,
                  label: l10n.surnameLabel,
                  enabled: !state.isLoading,
                  colors: colors,
                  onChanged: (v) =>
                      ref.read(onboardingProvider.notifier).setSurname(v),
                ),

                if (state.error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: colors.errorSub,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Text(
                      l10n.errorGeneric,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.error,
                          ),
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.xl),

                SizedBox(
                  height: AppSizes.buttonHeight,
                  child: FilledButton(
                    onPressed: state.isLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    child: state.isLoading
                        ? SizedBox.square(
                            dimension: AppSizes.iconMd,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.onPrimary,
                            ),
                          )
                        : Text(
                            l10n.continueLabel,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: cs.onPrimary),
                          ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({
    required this.languages,
    required this.selectedId,
    required this.onSelect,
  });

  final List<LanguageModel> languages;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final lang in languages)
          GestureDetector(
            onTap: () => onSelect(lang.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: lang.id == selectedId ? cs.primary : cs.outline,
                  width: lang.id == selectedId ? 2 : 1,
                ),
                color: lang.id == selectedId
                    ? cs.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang.flag, style: tt.titleLarge),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    lang.name,
                    style: tt.bodyMedium?.copyWith(
                      color: lang.id == selectedId ? cs.primary : null,
                      fontWeight: lang.id == selectedId
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _OnboardingTextField extends StatelessWidget {
  const _OnboardingTextField({
    required this.controller,
    required this.label,
    required this.colors,
    required this.onChanged,
    this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final AppColors colors;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      textCapitalization: TextCapitalization.words,
      style: tt.bodyLarge?.copyWith(color: colors.textPrimary),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: tt.bodyMedium,
        filled: true,
        fillColor: colors.surfaceRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
      ),
    );
  }
}
