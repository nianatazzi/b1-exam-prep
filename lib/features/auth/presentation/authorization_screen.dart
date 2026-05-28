import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

enum _AuthMode { signIn, signUp, resetPassword }

class AuthorizationScreen extends ConsumerStatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  ConsumerState<AuthorizationScreen> createState() =>
      _AuthorizationScreenState();
}

class _AuthorizationScreenState extends ConsumerState<AuthorizationScreen> {
  _AuthMode _mode = _AuthMode.signIn;
  bool _resetEmailSent = false;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    switch (_mode) {
      case _AuthMode.signIn:
        await ref
            .read(authProvider.notifier)
            .signIn(email: email, password: password);
      case _AuthMode.signUp:
        await ref
            .read(authProvider.notifier)
            .signUp(email: email, password: password);
      case _AuthMode.resetPassword:
        await ref
            .read(authProvider.notifier)
            .resetPassword(email: email);
        // Показываем баннер подтверждения, если ошибок нет
        if (mounted && !ref.read(authProvider).hasError) {
          setState(() => _resetEmailSent = true);
        }
    }
  }

  void _switchMode(_AuthMode mode) {
    setState(() {
      _mode = mode;
      _resetEmailSent = false;
    });
  }

  String _buttonLabel(AppLocalizations l10n) => switch (_mode) {
        _AuthMode.signIn => l10n.signIn,
        _AuthMode.signUp => l10n.signUp,
        _AuthMode.resetPassword => l10n.resetPassword,
      };

  String _errorText(Object? error, AppLocalizations l10n) => switch (error) {
        AuthError() => l10n.errorAuth,
        NetworkError() => l10n.errorNetwork,
        _ => l10n.errorGeneric,
      };

  List<Widget> _modeLinks(AppLocalizations l10n) => switch (_mode) {
        _AuthMode.signIn => [
            _ModeLink(
              prompt: l10n.noAccount,
              action: l10n.signUp,
              onTap: () => _switchMode(_AuthMode.signUp),
            ),
            const SizedBox(height: AppSpacing.xs),
            _ModeLink(
              action: l10n.forgotPassword,
              onTap: () => _switchMode(_AuthMode.resetPassword),
            ),
          ],
        _AuthMode.signUp => [
            _ModeLink(
              prompt: l10n.hasAccount,
              action: l10n.signIn,
              onTap: () => _switchMode(_AuthMode.signIn),
            ),
          ],
        _AuthMode.resetPassword => [
            _ModeLink(
              prompt: l10n.hasAccount,
              action: l10n.signIn,
              onTap: () => _switchMode(_AuthMode.signIn),
            ),
          ],
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final colors = Theme.of(context).extension<AppColors>()!;

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

                // Заголовок
                Text(
                  l10n.authWelcomeTitle,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.authWelcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x2l),

                // Поле email
                _AuthTextField(
                  controller: _emailCtrl,
                  label: l10n.email,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  colors: colors,
                ),

                // Поле пароля (скрыто в режиме восстановления)
                if (_mode != _AuthMode.resetPassword) ...[
                  const SizedBox(height: AppSpacing.md),
                  _AuthTextField(
                    controller: _passwordCtrl,
                    label: l10n.password,
                    obscureText: true,
                    enabled: !isLoading,
                    colors: colors,
                  ),
                ],

                // Баннер ошибки
                if (authState.hasError) ...[
                  const SizedBox(height: AppSpacing.md),
                  _StatusBanner(
                    message: _errorText(authState.asError?.error, l10n),
                    backgroundColor: colors.errorSub,
                    textColor: Theme.of(context).colorScheme.error,
                  ),
                ],

                // Баннер успеха после отправки письма
                if (_resetEmailSent && !authState.hasError) ...[
                  const SizedBox(height: AppSpacing.md),
                  _StatusBanner(
                    message: l10n.resetPasswordSent,
                    backgroundColor: colors.successSub,
                    textColor: colors.success,
                  ),
                ],

                const SizedBox(height: AppSpacing.xl),

                // Кнопка действия
                _AuthButton(
                  isLoading: isLoading,
                  label: _buttonLabel(l10n),
                  onPressed: isLoading ? null : _submit,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Ссылки переключения режима
                ..._modeLinks(l10n),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Вспомогательные виджеты ---

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.colors,
    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final AppColors colors;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      style: tt.bodyLarge?.copyWith(color: colors.textPrimary),
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
      // Возвращаем пробел чтобы поле было невалидным без визуального шума
      validator: (v) => (v == null || v.trim().isEmpty) ? ' ' : null,
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.isLoading,
    required this.label,
    required this.onPressed,
  });

  final bool isLoading;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        child: isLoading
            ? SizedBox.square(
                dimension: AppSizes.iconMd,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: cs.onPrimary,
                ),
              )
            : Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.onPrimary,
                    ),
              ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
  });

  final String message;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
            ),
      ),
    );
  }
}

class _ModeLink extends StatelessWidget {
  const _ModeLink({
    this.prompt,
    required this.action,
    required this.onTap,
  });

  final String? prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prompt != null) ...[
          Text(prompt!, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: AppSpacing.xs),
        ],
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(action),
        ),
      ],
    );
  }
}
