import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:b1_exam_prep/core/constants/app_sizes.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/core/theme/app_colors.dart';
import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';

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
  final _confirmPasswordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitGoogle() async {
    ref.read(authProvider.notifier).clearError();
    await ref.read(authProvider.notifier).signInWithGoogle();
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
        if (mounted && !ref.read(authProvider).hasError) {
          setState(() => _resetEmailSent = true);
        }
    }
  }

  void _switchMode(_AuthMode mode) {
    ref.read(authProvider.notifier).clearError();
    setState(() {
      _mode = mode;
      _resetEmailSent = false;
      _emailCtrl.clear();
      _passwordCtrl.clear();
      _confirmPasswordCtrl.clear();
    });
    // Сброс ошибок валидации после ребилда, иначе reset() конфликтует с clear()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.reset();
    });
  }

  String _buttonLabel(AppLocalizations l10n) => switch (_mode) {
        _AuthMode.signIn => l10n.signIn,
        _AuthMode.signUp => l10n.signUp,
        _AuthMode.resetPassword => l10n.resetPassword,
      };

  String _errorText(Object? error, AppLocalizations l10n) {
    if (error is AuthError) {
      return switch (error.code) {
        AuthErrorCode.wrongPassword => l10n.errorWrongPassword,
        AuthErrorCode.userNotFound => l10n.errorUserNotFound,
        AuthErrorCode.emailAlreadyInUse => l10n.errorEmailAlreadyInUse,
        AuthErrorCode.weakPassword => l10n.errorWeakPassword,
        AuthErrorCode.requiresRecentLogin => l10n.errorRequiresRecentLogin,
        null => l10n.errorAuth,
      };
    }
    return switch (error) {
      NetworkError() => l10n.errorNetwork,
      _ => l10n.errorGeneric,
    };
  }

  String? _validateEmail(String? v, AppLocalizations l10n) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return ' ';
    // Базовая проверка email-формата: наличие @ и домена
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return l10n.validationEmailInvalid;
    return null;
  }

  String? _validatePassword(String? v, AppLocalizations l10n) {
    final value = v ?? '';
    if (value.isEmpty) return ' ';
    if (value.length < 6) return l10n.validationPasswordTooShort;
    return null;
  }

  String? _validateConfirmPassword(String? v, AppLocalizations l10n) {
    if ((v ?? '') != _passwordCtrl.text) return l10n.validationPasswordMismatch;
    return null;
  }

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

                // Email
                _AuthTextField(
                  controller: _emailCtrl,
                  label: l10n.email,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  colors: colors,
                  validator: (v) => _validateEmail(v, l10n),
                ),

                // Пароль (скрыт в режиме восстановления)
                if (_mode != _AuthMode.resetPassword) ...[
                  const SizedBox(height: AppSpacing.md),
                  _PasswordTextField(
                    controller: _passwordCtrl,
                    label: l10n.password,
                    enabled: !isLoading,
                    colors: colors,
                    validator: (v) => _validatePassword(v, l10n),
                  ),
                ],

                // Подтверждение пароля (только при регистрации)
                if (_mode == _AuthMode.signUp) ...[
                  const SizedBox(height: AppSpacing.md),
                  _PasswordTextField(
                    controller: _confirmPasswordCtrl,
                    label: l10n.confirmPassword,
                    enabled: !isLoading,
                    colors: colors,
                    validator: (v) => _validateConfirmPassword(v, l10n),
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

                _AuthButton(
                  isLoading: isLoading,
                  label: _buttonLabel(l10n),
                  onPressed: isLoading ? null : _submit,
                ),

                const SizedBox(height: AppSpacing.lg),

                ..._modeLinks(l10n),

                // Google Sign-In (только для входа и регистрации)
                if (_mode != _AuthMode.resetPassword) ...[
                  const SizedBox(height: AppSpacing.x2l),
                  _OrDivider(label: l10n.orLabel),
                  const SizedBox(height: AppSpacing.x2l),
                  _GoogleButton(
                    isLoading: isLoading,
                    label: l10n.continueWithGoogle,
                    onPressed: isLoading ? null : _submitGoogle,
                  ),
                ],

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
    required this.validator,
    this.keyboardType,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final AppColors colors;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      style: tt.bodyLarge?.copyWith(color: colors.textPrimary),
      validator: validator,
      decoration: _buildDecoration(context, cs, tt),
    );
  }

  InputDecoration _buildDecoration(
    BuildContext context,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return InputDecoration(
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
    );
  }
}

/// Поле пароля с кнопкой показать/скрыть — локальное состояние в виджете.
class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    required this.controller,
    required this.label,
    required this.colors,
    required this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final AppColors colors;
  final FormFieldValidator<String> validator;
  final bool enabled;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      enabled: widget.enabled,
      style: tt.bodyLarge?.copyWith(color: widget.colors.textPrimary),
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: tt.bodyMedium,
        filled: true,
        fillColor: widget.colors.surfaceRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: widget.colors.textSecondary,
            size: AppSizes.iconMd,
          ),
          onPressed: widget.enabled
              ? () => setState(() => _obscure = !_obscure)
              : null,
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

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.textMuted),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({
    required this.isLoading,
    required this.label,
    required this.onPressed,
  });

  final bool isLoading;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          side: BorderSide(color: colors.n400),
        ),
        child: isLoading
            ? SizedBox.square(
                dimension: AppSizes.iconMd,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Буква G в фирменных цветах Google
                  const Text(
                    'G',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4285F4),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colors.textPrimary,
                        ),
                  ),
                ],
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
