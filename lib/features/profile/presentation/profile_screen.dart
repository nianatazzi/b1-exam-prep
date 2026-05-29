import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/locale/locale_provider.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/profile/presentation/profile_notifier.dart';
import 'package:linguobyte/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.profileTitle),
        actions: [
          // Переход на HomeScreen — pop если возможно, иначе go
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: l10n.homeTitle,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const _ProfileShimmer(),
        error: (_, _) => _ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(profileProvider),
        ),
        data: (data) => _ProfileContent(data: data),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Контент профиля
// ---------------------------------------------------------------------------

class _ProfileContent extends ConsumerStatefulWidget {
  final ProfileData data;

  const _ProfileContent({required this.data});

  @override
  ConsumerState<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends ConsumerState<_ProfileContent> {
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.data.publicProfile.name,
    );
    _surnameController = TextEditingController(
      text: widget.data.publicProfile.surname,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // Сохраняем messenger до await — после rebuild контекст может быть недоступен
    final messenger = ScaffoldMessenger.of(context);
    final savedMessage = AppLocalizations.of(context)!.profileSaved;

    setState(() => _isEditing = false);
    await ref.read(profileProvider.notifier).updateProfile({
      'name': _nameController.text.trim(),
      'surname': _surnameController.text.trim(),
    });
    messenger.showSnackBar(SnackBar(content: Text(savedMessage)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final pub = widget.data.publicProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.x2l,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Avatar(avatar: pub.avatar, name: pub.name, surname: pub.surname),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${pub.points} ${l10n.points}',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.x2l),

          // IgnorePointer — поле всегда выглядит активным (нет opacity),
          // но не реагирует на касания вне режима редактирования.
          IgnorePointer(
            ignoring: !_isEditing,
            child: TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.nameLabel),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          IgnorePointer(
            ignoring: !_isEditing,
            child: TextField(
              controller: _surnameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.surnameLabel),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Кнопка «Сохранить» — только в режиме редактирования
          if (_isEditing)
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(l10n.save),
              ),
            ),

          const SizedBox(height: AppSpacing.x2l),
          _UiLanguageSection(isEditing: _isEditing),
          const SizedBox(height: AppSpacing.x2l),

          // Кнопка «Редактировать» — оранжевая, только вне режима редактирования
          if (!_isEditing)
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: OutlinedButton(
                onPressed: () => setState(() => _isEditing = true),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.secondary,
                  side: BorderSide(color: theme.colorScheme.secondary),
                ),
                child: Text(l10n.editLabel),
              ),
            ),

          const SizedBox(height: AppSpacing.md),
          const _SignOutButton(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Аватар
// ---------------------------------------------------------------------------

class _Avatar extends StatelessWidget {
  final String? avatar;
  final String name;
  final String surname;

  const _Avatar({
    required this.avatar,
    required this.name,
    required this.surname,
  });

  @override
  Widget build(BuildContext context) {
    const radius = AppSizes.avatarXl / 2;

    if (avatar != null && avatar!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: avatar!,
        imageBuilder: (_, imageProvider) => CircleAvatar(
          radius: radius,
          backgroundImage: imageProvider,
        ),
        placeholder: (_, _) => _AvatarFallback(
          name: name,
          surname: surname,
          radius: radius,
        ),
        errorWidget: (_, _, _) => _AvatarFallback(
          name: name,
          surname: surname,
          radius: radius,
        ),
      );
    }

    return _AvatarFallback(name: name, surname: surname, radius: radius);
  }
}

class _AvatarFallback extends StatelessWidget {
  final String name;
  final String surname;
  final double radius;

  const _AvatarFallback({
    required this.name,
    required this.surname,
    required this.radius,
  });

  String get _initials {
    final first = name.isNotEmpty ? name[0].toUpperCase() : '';
    final last = surname.isNotEmpty ? surname[0].toUpperCase() : '';
    return '$first$last';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primary,
      child: _initials.isNotEmpty
          ? Text(
              _initials,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            )
          : Icon(
              Icons.person,
              size: radius,
              color: theme.colorScheme.onPrimary,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Выбор языка интерфейса
// ---------------------------------------------------------------------------

class _UiLanguageSection extends ConsumerWidget {
  final bool isEditing;

  const _UiLanguageSection({required this.isEditing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final activeLocale = ref.watch(appLocaleProvider);
    final activeCode =
        activeLocale?.languageCode ??
        Localizations.localeOf(context).languageCode;

    final languages = [
      ('en', l10n.langEnglish),
      ('ru', l10n.langRussian),
      ('fr', l10n.langFrench),
      ('es', l10n.langSpanish),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.languageLabel, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: languages.map((lang) {
            final isSelected = activeCode == lang.$1;
            // Активная кнопка — всегда ElevatedButton (выделена визуально).
            // Остальные кнопки кликабельны только в режиме редактирования.
            return isSelected
                ? ElevatedButton(
                    onPressed: null,
                    child: Text(lang.$2),
                  )
                : OutlinedButton(
                    onPressed: isEditing
                        ? () => ref
                            .read(profileProvider.notifier)
                            .setUiLanguage(lang.$1)
                        : null,
                    child: Text(lang.$2),
                  );
          }).toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Кнопка выхода
// ---------------------------------------------------------------------------

class _SignOutButton extends ConsumerWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isSigningOut = ref.watch(authProvider).isLoading;

    return SizedBox(
      height: AppSizes.buttonHeight,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isSigningOut
            ? null
            : () => ref.read(authProvider.notifier).signOut(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          side: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        child: isSigningOut
            ? SizedBox(
                width: AppSizes.iconMd,
                height: AppSizes.iconMd,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            : Text(l10n.signOut),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer — скелет загрузки
// ---------------------------------------------------------------------------

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Shimmer.fromColors(
      baseColor: colors.surfaceRaised,
      highlightColor: colors.surfaceOverlay,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.x2l,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: AppSizes.avatarXl / 2,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: AppSpacing.sm),
            _ShimmerBox(width: 80, height: 16),
            const SizedBox(height: AppSpacing.x2l),
            _ShimmerBox(height: AppSizes.buttonHeight),
            const SizedBox(height: AppSpacing.md),
            _ShimmerBox(height: AppSizes.buttonHeight),
            const SizedBox(height: AppSpacing.x2l),
            Align(
              alignment: Alignment.centerLeft,
              child: _ShimmerBox(width: 140, height: 17),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: List.generate(
                4,
                (_) => _ShimmerBox(width: 100, height: AppSizes.buttonHeightSm),
              ),
            ),
            const SizedBox(height: AppSpacing.x2l),
            _ShimmerBox(height: AppSizes.buttonHeight),
            const SizedBox(height: AppSpacing.md),
            _ShimmerBox(height: AppSizes.buttonHeight),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;

  const _ShimmerBox({this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Экран ошибки
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
