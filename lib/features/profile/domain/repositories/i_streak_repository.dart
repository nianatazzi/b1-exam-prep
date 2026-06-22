abstract class IStreakRepository {
  /// Обновляет стрик: если новый день — инкрементирует или сбрасывает.
  /// Возвращает обновлённый currentStreak.
  Future<int> updateStreak(String userId);
}
