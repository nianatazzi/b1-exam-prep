import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';

/// Результат проверки: какое достижение нужно обновить и до какого уровня.
/// Общий тип для linguobyte (CheckAchievementUseCase) и B1
/// (CheckB1AchievementUseCase) — оба проверяют один и тот же набор из 5
/// достижений, но с разными триггерами.
class AchievementUpdate {
  final AchievementType type;
  final int newLevel;

  const AchievementUpdate({required this.type, required this.newLevel});
}
