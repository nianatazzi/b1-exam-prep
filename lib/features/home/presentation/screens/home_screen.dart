import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/home/domain/models/language_model.dart';
import 'package:linguobyte/features/home/domain/usecases/get_home_data_use_case.dart';
import 'package:linguobyte/features/home/presentation/providers/home_notifier.dart';
import 'package:linguobyte/features/home/presentation/widgets/lesson_card.dart';
import 'package:linguobyte/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  static const double _cardGap = AppSpacing.md;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Прокручивает список к активной карточке после отрисовки кадра.
  void _scrollToActive(HomeState state) {
    final index = state.screenData.lessonCards.indexWhere(
      (c) => c.state == LessonCardState.active,
    );
    if (index <= 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final offset = AppSpacing.lg + index * (AppSizes.lessonCardWidth + _cardGap);
      final max = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        offset.clamp(0.0, max),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  /// Показывает bottom sheet со списком языков.
  void _showLanguagePicker(
    BuildContext context,
    List<LanguageModel> languages,
    String selectedLangId,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _LanguagePickerSheet(
        languages: languages,
        selectedLangId: selectedLangId,
        onSelect: (langId) {
          Navigator.of(context).pop();
          ref.read(homeProvider.notifier).selectLanguage(langId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final homeAsync = ref.watch(homeProvider);
    final homeState = homeAsync.asData?.value;

    ref.listen(homeProvider, (_, next) {
      next.whenData(_scrollToActive);
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── ВЕРХНЯЯ СТРОКА: селектор языка + профиль ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  // Чип выбранного языка — при нажатии открывает bottom sheet
                  if (homeState != null)
                    _SelectedLangChip(
                      languages: homeState.languages,
                      selectedLangId: homeState.selectedLangId,
                      onTap: () => _showLanguagePicker(
                        context,
                        homeState.languages,
                        homeState.selectedLangId,
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    iconSize: AppSizes.profileIconSize,
                    tooltip: l10n.profileTitle,
                    onPressed: () => context.push(AppRoutes.profile),
                  ),
                ],
              ),
            ),

            // ── КАРТОЧКИ УРОКОВ ──
            Expanded(
              child: homeAsync.when(
                loading: () => const _HomeShimmer(),
                error: (_, _) => _ErrorView(
                  message: l10n.errorGeneric,
                  onRetry: () => ref.invalidate(homeProvider),
                ),
                data: (state) => _LessonList(
                  cards: state.screenData.lessonCards,
                  controller: _scrollController,
                  cardGap: _cardGap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Чип выбранного языка (флаг + код) ───────────────────────────────────────

class _SelectedLangChip extends StatelessWidget {
  final List<LanguageModel> languages;
  final String selectedLangId;
  final VoidCallback onTap;

  const _SelectedLangChip({
    required this.languages,
    required this.selectedLangId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<AppColors>()!;

    final selected = languages.firstWhere(
      (l) => l.id == selectedLangId,
      orElse: () => languages.first,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.primarySub,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(color: cs.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selected.flag, style: theme.textTheme.bodyMedium),
            const SizedBox(width: AppSpacing.xs),
            Text(
              selectedLangId.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(color: cs.primary),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.expand_more, size: AppSizes.iconSm, color: cs.primary),
          ],
        ),
      ),
    );
  }
}

// ── Bottom sheet со списком языков ───────────────────────────────────────────

class _LanguagePickerSheet extends StatelessWidget {
  final List<LanguageModel> languages;
  final String selectedLangId;
  final ValueChanged<String> onSelect;

  const _LanguagePickerSheet({
    required this.languages,
    required this.selectedLangId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ручка
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),
            for (final lang in languages)
              ListTile(
                leading: Text(lang.flag, style: theme.textTheme.titleLarge),
                title: Text(
                  lang.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: lang.id == selectedLangId ? cs.primary : cs.onSurface,
                  ),
                ),
                trailing: lang.id == selectedLangId
                    ? Icon(Icons.check_rounded, color: cs.primary)
                    : null,
                onTap: () => onSelect(lang.id),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Горизонтальный список карточек уроков ───────────────────────────────────

class _LessonList extends StatelessWidget {
  final List<LessonCardData> cards;
  final ScrollController controller;
  final double cardGap;

  const _LessonList({
    required this.cards,
    required this.controller,
    required this.cardGap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (cards.isEmpty) {
      return Center(
        child: Text(
          l10n.errorNotFound,
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      // ConstrainedBox центрирует карточки когда их мало,
      // и позволяет скроллить когда их много
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - AppSpacing.lg * 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) SizedBox(width: cardGap),
              LessonCard(
                cardData: cards[i],
                lessonIndex: i,
                onTap: cards[i].state == LessonCardState.locked
                    ? null
                    : () => context.push(
                        AppRoutes.lessonPath(cards[i].lesson.id),
                      ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}

// ── Скелет загрузки ─────────────────────────────────────────────────────────

class _HomeShimmer extends StatelessWidget {
  const _HomeShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Shimmer.fromColors(
      baseColor: colors.surfaceRaised,
      highlightColor: colors.surfaceOverlay,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(3, (i) {
            return Container(
              width: AppSizes.lessonCardWidth,
              height: AppSizes.lessonCardHeight,
              margin: EdgeInsets.only(right: i < 2 ? AppSpacing.md : 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Экран ошибки ─────────────────────────────────────────────────────────────

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
