import 'package:flutter/material.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_rule_model.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';

class GrammarTableWidget extends StatelessWidget {
  final GrammarRuleModel rule;

  const GrammarTableWidget({super.key, required this.rule});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    final ruleTypeLabel = switch (rule.ruleType) {
      GrammarRuleType.declension => l10n.b1Declension,
      GrammarRuleType.conjugation => l10n.b1Conjugation,
      GrammarRuleType.caseUsage => l10n.b1CaseUsage,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(label: Text(ruleTypeLabel)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    rule.title,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (rule.explanation.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                (rule.explanation[locale] ?? rule.explanation['en'] ?? '')
                    .toString(),
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (rule.paradigm.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _buildParadigmTable(context),
            ],
            if (rule.examples.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              ...rule.examples.map((example) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(
                      '${example['pl'] ?? ''} — ${example[locale] ?? example['en'] ?? ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParadigmTable(BuildContext context) {
    final theme = Theme.of(context);
    final entries = rule.paradigm.entries.toList();

    return Table(
      border: TableBorder.all(
        color: theme.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      children: entries.map((entry) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                entry.key,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                entry.value.toString(),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
