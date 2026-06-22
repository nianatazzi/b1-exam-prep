// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_model.freezed.dart';
part 'streak_model.g.dart';

@freezed
abstract class StreakModel with _$StreakModel {
  const StreakModel._();

  const factory StreakModel({
    @Default(0) int currentStreak,
    @Default(0) int bestStreak,
    DateTime? lastActiveDate,
  }) = _StreakModel;

  factory StreakModel.fromJson(Map<String, dynamic> json) =>
      _$StreakModelFromJson(json);

  /// Возвращает список из 7 bool для M T W T F S S:
  /// true = день активности, false = пропущен или будущий.
  /// Стрик привязан к lastActiveDate: активные дни — это
  /// [lastActiveDate - currentStreak + 1 .. lastActiveDate].
  List<bool> weekDays(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));

    if (lastActiveDate == null || currentStreak <= 0) {
      return List.filled(7, false);
    }

    final lastDay = DateTime(
      lastActiveDate!.year, lastActiveDate!.month, lastActiveDate!.day,
    );
    final firstDay = lastDay.subtract(Duration(days: currentStreak - 1));

    return List.generate(7, (i) {
      final day = monday.add(Duration(days: i));
      if (day.isAfter(today)) return false;
      return !day.isBefore(firstDay) && !day.isAfter(lastDay);
    });
  }
}
