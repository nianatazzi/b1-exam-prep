import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b1_exam_prep/core/constants/app_routes.dart';
import 'package:b1_exam_prep/core/constants/app_sizes.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/core/constants/avatar_presets.dart';
import 'package:b1_exam_prep/core/theme/app_colors.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';
import 'package:b1_exam_prep/features/profile/domain/exercise_stats_model.dart';
import 'package:b1_exam_prep/features/profile/domain/public_user_model.dart';
import 'package:b1_exam_prep/features/profile/domain/streak_model.dart';
import 'package:b1_exam_prep/features/profile/presentation/profile_notifier.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';
import 'package:b1_exam_prep/shared/widgets/avatar_picker_grid.dart';
import 'package:b1_exam_prep/shared/widgets/error_view.dart';
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
                context.go(AppRoutes.b1Home);
              }
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const _ProfileShimmer(),
        error: (_, _) => ErrorView(
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

class _ProfileContent extends StatelessWidget {
  final ProfileData data;
  const _ProfileContent({required this.data});

  void _openEditSheet(BuildContext context, PublicUserModel pub) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _EditProfileSheet(profile: pub),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final pub = data.publicProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _EditableAvatar(
            profile: pub,
            onTap: () => _openEditSheet(context, pub),
          ),
          const SizedBox(height: AppSpacing.md),
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

          const SizedBox(height: AppSpacing.xl),
          _StreakCard(streak: data.streak),
          const SizedBox(height: AppSpacing.xl),
          _ProficiencySection(stats: data.stats),
          const SizedBox(height: AppSpacing.xl),
          _AchievementsSection(achievements: data.achievements),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Аватар с кнопкой-карандашом + лист редактирования
// ---------------------------------------------------------------------------

/// Аватар с круглым значком-карандашом в углу. Тап по всей области → onTap.
class _EditableAvatar extends StatelessWidget {
  final PublicUserModel profile;
  final VoidCallback onTap;

  const _EditableAvatar({required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          _Avatar(
            avatar: profile.avatar,
            name: profile.name,
            surname: profile.surname,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary,
                // Обводка цветом фона — значок «вырезан» из аватара
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: AppSizes.iconSm,
                color: cs.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Лист редактирования профиля: сетка аватаров + имя/фамилия + сохранение.
class _EditProfileSheet extends ConsumerStatefulWidget {
  final PublicUserModel profile;
  const _EditProfileSheet({required this.profile});

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _surnameCtrl;
  late String _avatar;
  bool _isSaving = false;
  String? _saveError;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.name);
    _surnameCtrl = TextEditingController(text: widget.profile.surname);
    final current = widget.profile.avatar;
    _avatar =
        (current != null && current.isNotEmpty) ? current : AvatarPresets.defaultId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() {
      _isSaving = true;
      _saveError = null;
    });
    final ok = await ref.read(profileProvider.notifier).updateProfile({
      'name': _nameCtrl.text.trim(),
      'surname': _surnameCtrl.text.trim(),
      'avatar': _avatar,
    });
    if (!mounted) return;
    if (ok) {
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
    } else {
      // Ошибку показываем инлайн в листе (snackbar мог бы оказаться под ним).
      setState(() {
        _isSaving = false;
        _saveError = l10n.errorGeneric;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.editProfileTitle,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              AvatarPickerGrid(
                selectedId: _avatar,
                onSelect: (id) => setState(() => _avatar = id),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                enabled: !_isSaving,
                decoration: InputDecoration(labelText: '${l10n.firstName} *'),
                validator: (v) => (v?.trim().isEmpty ?? true)
                    ? l10n.validationFieldRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _surnameCtrl,
                textCapitalization: TextCapitalization.words,
                enabled: !_isSaving,
                decoration: InputDecoration(labelText: l10n.surname),
              ),
              if (_saveError != null) ...[
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
                    _saveError!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: AppSizes.buttonHeight,
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? SizedBox.square(
                          dimension: AppSizes.iconMd,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : Text(l10n.save),
                ),
              ),
            ],
          ),
        ),
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
    const radius = AppSizes.avatarXxl / 2;

    if (avatar != null && avatar!.isNotEmpty) {
      // Локальный пресет — id вида 'avatar_01'
      if (AvatarPresets.ids.contains(avatar)) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: AssetImage(AvatarPresets.pathOf(avatar!)),
        );
      }
      // Сетевой URL (Firebase Storage, будущее расширение)
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
              radius: AppSizes.avatarXxl / 2,
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
