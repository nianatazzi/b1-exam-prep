// Страховочная сетка (волна 0): чистая логика стрика и процентов.
import 'package:flutter_test/flutter_test.dart';
import 'package:linguobyte/features/profile/domain/stat_entry_model.dart';
import 'package:linguobyte/features/profile/domain/streak_model.dart';

void main() {
  group('StatEntryModel.percent', () {
    test('0 при total == 0 (без деления на ноль)', () {
      expect(const StatEntryModel().percent, 0);
    });

    test('округляет до целого процента', () {
      expect(const StatEntryModel(correct: 3, total: 4).percent, 75);
      expect(const StatEntryModel(correct: 1, total: 3).percent, 33);
    });
  });

  group('StreakModel.weekDays', () {
    // 2026-06-23 — вторник (weekday == 2); календарная неделя Mon22..Sun28.
    final tuesday = DateTime(2026, 6, 23);

    test('пустой стрик → все дни false', () {
      const model = StreakModel(currentStreak: 0);
      expect(model.weekDays(tuesday), List.filled(7, false));
    });

    test('стрик в 3 дня, заканчивающийся во вторник, '
        'подсвечивает только Mon и Tue текущей недели', () {
      // Стрик Sun21+Mon22+Tue23, но Sun21 — на прошлой календарной неделе.
      final model = StreakModel(currentStreak: 3, lastActiveDate: tuesday);
      final days = model.weekDays(tuesday); // [Mon..Sun]
      expect(days[0], isTrue, reason: 'Mon 22 входит в стрик');
      expect(days[1], isTrue, reason: 'Tue 23 — последний день стрика');
      expect(days.sublist(2), List.filled(5, false),
          reason: 'Wed..Sun — будущее или вне стрика');
    });

    test('будущие дни недели всегда false', () {
      final model = StreakModel(currentStreak: 1, lastActiveDate: tuesday);
      final days = model.weekDays(tuesday);
      expect(days[2], isFalse); // Wed
      expect(days[3], isFalse); // Thu
    });
  });
}
