import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/exercise_stats_model.dart';
import 'package:linguobyte/features/profile/domain/streak_model.dart';
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
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
            onPressed: () => context.push(AppRoutes.settings),
          ),
          IconButton(
            icon: const Icon(Icons.home),
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
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Avatar(avatar: pub.avatar, name: pub.name, surname: pub.surname),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${pub.name} ${pub.surname}'.trim(),
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${pub.points} ${l10n.points}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.extension<AppColors>()!.textSecondary,
            ),
          ),

          // Редактирование имени
          if (_isEditing) ...[
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.firstName),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _surnameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.surname),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(l10n.save),
              ),
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => setState(() => _isEditing = true),
              child: Text(l10n.editLabel),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),
          _StreakCard(streak: widget.data.streak),
          const SizedBox(height: AppSpacing.xl),
          _ProficiencySection(stats: widget.data.stats),
          const SizedBox(height: AppSpacing.xl),
          _AchievementsSection(achievements: widget.data.achievements),
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
// Карточка серии (streak)
// ---------------------------------------------------------------------------

class _StreakCard extends StatelessWidget {
  final StreakModel streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final weekDays = streak.weekDays(DateTime.now());
    final dayLabels = [
      l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu,
      l10n.dayFri, l10n.daySat, l10n.daySun,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.currentStreakLabel,
                  style: theme.textTheme.titleMedium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.primarySub,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Text(
                  l10n.bestStreakLabel(streak.bestStreak),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${streak.currentStreak}',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(l10n.daysLabel, style: theme.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final active = weekDays[i];
              return Column(
                children: [
                  Container(
                    width: AppSizes.streakDot,
                    height: AppSizes.streakDot,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active
                          ? theme.colorScheme.primary
                          : colors.surfaceOverlay,
                    ),
                    child: active
                        ? Icon(Icons.check,
                            size: AppSizes.iconSm, color: theme.colorScheme.onPrimary)
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    dayLabels[i],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Радар-чарт компетенций
// ---------------------------------------------------------------------------

class _ProficiencySection extends StatelessWidget {
  final ExerciseStatsModel stats;
  const _ProficiencySection({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    final labels = [
      l10n.grammarLabel,
      l10n.vocabularyLabel,
      l10n.listeningSkillLabel,
      l10n.speakingLabel,
    ];
    final values = [
      stats.grammar.percent / 100,
      stats.vocabulary.percent / 100,
      stats.listening.percent / 100,
      stats.speaking.percent / 100,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.proficiencySection.toUpperCase(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: SizedBox(
            height: 220,
            child: _RadarChart(
              labels: labels,
              values: values,
            ),
          ),
        ),
      ],
    );
  }
}

class _RadarChart extends StatelessWidget {
  final List<String> labels;
  final List<double> values;

  const _RadarChart({required this.labels, required this.values});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
            fillColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            borderColor: theme.colorScheme.primary,
            borderWidth: 2,
            entryRadius: 3,
          ),
        ],
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        radarBorderData: BorderSide(color: colors.surfaceOverlay, width: 1),
        gridBorderData: BorderSide(color: colors.surfaceOverlay, width: 1),
        tickCount: 4,
        ticksTextStyle: const TextStyle(fontSize: 0),
        tickBorderData: BorderSide(color: colors.surfaceOverlay, width: 0.5),
        titlePositionPercentageOffset: 0.2,
        titleTextStyle: theme.textTheme.labelSmall!.copyWith(
          color: colors.textSecondary,
        ),
        getTitle: (index, _) => RadarChartTitle(text: labels[index]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Секция достижений
// ---------------------------------------------------------------------------

class _AchievementsSection extends StatelessWidget {
  final List<AchievementModel> achievements;
  const _AchievementsSection({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.achievementsSection.toUpperCase(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...achievements.map((a) => _AchievementTile(achievement: a)),
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final AchievementModel achievement;
  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final unlocked = achievement.level > 0;

    final (name, desc) = switch (achievement.type) {
      AchievementType.masterConjugator => (
          l10n.achievementMasterConjugator,
          l10n.achievementMasterConjugatorDesc,
        ),
      AchievementType.firstStep => (
          l10n.achievementFirstStep,
          l10n.achievementFirstStepDesc,
        ),
      AchievementType.focusedLearner => (
          l10n.achievementFocusedLearner,
          l10n.achievementFocusedLearnerDesc,
        ),
      AchievementType.interestedLearner => (
          l10n.achievementInterestedLearner,
          l10n.achievementInterestedLearnerDesc,
        ),
      AchievementType.vocabularyMaster => (
          l10n.achievementVocabularyMaster,
          l10n.achievementVocabularyMasterDesc,
        ),
    };

    final icon = switch (achievement.type) {
      AchievementType.masterConjugator => Icons.workspace_premium,
      AchievementType.firstStep => Icons.flag,
      AchievementType.focusedLearner => Icons.local_fire_department,
      AchievementType.interestedLearner => Icons.explore,
      AchievementType.vocabularyMaster => Icons.menu_book,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.achievementIconBg,
            height: AppSizes.achievementIconBg,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked ? colors.primarySub : colors.surfaceOverlay,
            ),
            child: Icon(
              icon,
              color: unlocked
                  ? theme.colorScheme.primary
                  : colors.textMuted,
              size: AppSizes.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: unlocked ? null : colors.textMuted,
                  ),
                ),
                Text(
                  desc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (achievement.level > 1)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: colors.primarySub,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Text(
                '×${achievement.level}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer
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
          vertical: AppSpacing.lg,
        ),
        child: Column(
          children: [
            const CircleAvatar(
              radius: AppSizes.avatarXl / 2,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: AppSpacing.sm),
            _ShimmerBox(width: 120, height: 20),
            const SizedBox(height: AppSpacing.xs),
            _ShimmerBox(width: 80, height: 14),
            const SizedBox(height: AppSpacing.xl),
            _ShimmerBox(height: 160),
            const SizedBox(height: AppSpacing.xl),
            _ShimmerBox(height: 220),
            const SizedBox(height: AppSpacing.xl),
            ...List.generate(
                3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _ShimmerBox(height: 68),
                )),
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
            Text(message, style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center),
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
