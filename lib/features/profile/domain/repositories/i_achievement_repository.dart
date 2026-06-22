import 'package:linguobyte/features/profile/domain/achievement_model.dart';

abstract class IAchievementRepository {
  /// Обновляет достижение: записывает новый уровень в Firestore.
  Future<void> updateAchievement({
    required String userId,
    required String langId,
    required AchievementType type,
    required int newLevel,
  });
}
