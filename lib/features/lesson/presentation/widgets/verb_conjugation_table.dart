import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

/// Таблица спряжения одного глагола.
///
/// Ожидаемая структура [conjugation]:
///   { "future" | "present" | "past" :
///       { "question" | "positive" | "negative" :
///           { "je" | "tu" | "il/elle" | "ils/elles" | "nous" | "vous" : String }
///       }
///   }
class VerbConjugationTable extends StatelessWidget {
  final Map<String, dynamic> conjugation;

  static const _tenseKeys = ['future', 'present', 'past'];
  static const _polarityKeys = ['question', 'positive', 'negative'];
  static const _polaritySymbols = ['?', '+', '−'];
  static const _pronounKeys = [
    'je',
    'tu',
    'il/elle',
    'ils/elles',
    'nous',
    'vous',
  ];

  const VerbConjugationTable({super.key, required this.conjugation});

  String _tenseName(String key, AppLocalizations l10n) => switch (key) {
        'future' => l10n.tenseFuture,
        'present' => l10n.tensePresent,
        'past' => l10n.tensePast,
        _ => key,
      };

  String _form(Map<String, dynamic> tenseData, String polarity, String pronoun) {
    final pMap = tenseData[polarity];
    if (pMap is! Map) return '—';
    return pMap[pronoun]?.toString() ?? '—';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final headerStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: cs.primary,
    );
    final tenseStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: cs.onSurface.withValues(alpha: 0.55),
      letterSpacing: 0.6,
    );
    final pronounStyle = theme.textTheme.bodySmall?.copyWith(
      color: cs.onSurface.withValues(alpha: 0.55),
      fontWeight: FontWeight.w500,
    );
    final cellStyle = theme.textTheme.bodySmall;

    final outerBorder = BorderSide(color: cs.onSurface.withValues(alpha: 0.12));
    final innerBorder = BorderSide(color: cs.onSurface.withValues(alpha: 0.07));
    final tenseDivider = BorderSide(color: cs.onSurface.withValues(alpha: 0.14));

    final rows = <TableRow>[
      // Строка заголовка: [пусто] | ? | + | −
      TableRow(
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.08),
        ),
        children: [
          _pad(const SizedBox.shrink()),
          for (final symbol in _polaritySymbols)
            _pad(
              Text(symbol, style: headerStyle, textAlign: TextAlign.center),
            ),
        ],
      ),
    ];

    for (final tenseKey in _tenseKeys) {
      final raw = conjugation[tenseKey];
      if (raw is! Map) continue;
      final tenseData = Map<String, dynamic>.from(raw);

      // Строка-разделитель с названием времени
      rows.add(TableRow(
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.04),
          border: Border(top: tenseDivider),
        ),
        children: [
          _pad(
            Text(
              _tenseName(tenseKey, l10n).toUpperCase(),
              style: tenseStyle,
            ),
          ),
          const SizedBox.shrink(),
          const SizedBox.shrink(),
          const SizedBox.shrink(),
        ],
      ));

      // Строки по местоимениям
      for (final pronoun in _pronounKeys) {
        rows.add(TableRow(
          decoration: BoxDecoration(
            border: Border(top: innerBorder),
          ),
          children: [
            _pad(Text(pronoun, style: pronounStyle)),
            for (final polarity in _polarityKeys)
              _pad(Text(_form(tenseData, polarity, pronoun), style: cellStyle)),
          ],
        ));
      }
    }

    return Table(
      border: TableBorder(
        top: outerBorder,
        bottom: outerBorder,
        left: outerBorder,
        right: outerBorder,
        verticalInside: innerBorder,
        borderRadius: BorderRadius.circular(8),
      ),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: rows,
    );
  }

  Widget _pad(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: child,
      );
}
