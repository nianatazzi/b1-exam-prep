import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/shared/widgets/audio_play_button.dart';

class WordcardExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;
  final ValueChanged<ExerciseResult>? onResult;

  const WordcardExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
    this.onResult,
  });

  @override
  State<WordcardExerciseWidget> createState() => _WordcardExerciseWidgetState();
}

class _WordcardExerciseWidgetState extends State<WordcardExerciseWidget> {
  @override
  void initState() {
    super.initState();
    // Wordcard — режим изучения, не проверки: кнопка "Далее" доступна сразу
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onReady());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ac = theme.extension<AppColors>()!;
    final td = widget.exercise.typeData ?? {};
    final langCode = Localizations.localeOf(context).languageCode;

    final baseWord = (td['base_word'] as String?) ?? '';
    final pronunciation = (td['pronunciation'] as String?) ?? '';

    // article содержит описательный текст о слове, не грамматический артикль
    final articleMap = (td['article'] as Map?)?.cast<String, dynamic>() ?? {};
    final articleText =
        (articleMap[langCode] ?? articleMap['en'] ?? '').toString().trim();

    final translationsMap =
        (td['translations'] as Map?)?.cast<String, dynamic>() ?? {};
    final rawTranslations = translationsMap[langCode] ?? translationsMap['en'];
    final List<String> translations;
    if (rawTranslations is List) {
      translations = rawTranslations.cast<String>();
    } else if (rawTranslations is String && rawTranslations.isNotEmpty) {
      // Firestore хранит переводы как строку вида: "Вариант 1", "Вариант 2"
      final matches = RegExp(r'"([^"]+)"').allMatches(rawTranslations);
      translations = matches.isNotEmpty
          ? matches.map((m) => m.group(1)!).toList()
          : [rawTranslations];
    } else {
      translations = [];
    }

    final audioUrl = widget.exercise.audioUrl;
    final imageUrl = widget.exercise.imageUrl;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Слово
          Text(
            baseWord,
            textAlign: TextAlign.center,
            style:
                theme.textTheme.displayLarge?.copyWith(color: ac.textPrimary),
          ),

          if (pronunciation.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '[$pronunciation]',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: ac.textMuted),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Аудиокнопка
          AudioPlayButton(audioUrl: audioUrl),

          const SizedBox(height: AppSpacing.xl),

          // Изображение или placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: hasImage
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _ImagePlaceholder(ac: ac),
                    errorWidget: (context, url, error) =>
                        _ImagePlaceholder(ac: ac),
                  )
                : _ImagePlaceholder(ac: ac),
          ),

          // Описательный текст
          if (articleText.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              articleText,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: ac.textSecondary),
            ),
          ],

          // Переводы — каждый в отдельной рамке
          if (translations.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: translations
                  .map((t) => _TranslationChip(label: t, ac: ac))
                  .toList(),
            ),
          ],

          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final AppColors ac;

  const _ImagePlaceholder({required this.ac});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: ac.surfaceOverlay,
        border: Border.all(color: ac.n600),
      ),
      child: Icon(
        Icons.image_rounded,
        size: AppSizes.iconLg * 1.5,
        color: ac.textMuted,
      ),
    );
  }
}

class _TranslationChip extends StatelessWidget {
  final String label;
  final AppColors ac;

  const _TranslationChip({required this.label, required this.ac});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: ac.surfaceOverlay,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ac.n500),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: ac.textPrimary),
      ),
    );
  }
}
