// Регресс-тест волны 1 (баг 1.1): достижения больше не роняют парсинг прогресса.
// До фикса AchievementModel.fromJson падал на ArgumentError (нет type),
// и getUserLanguageProgress отдавал UnknownError → Home/Profile/Lesson в error.
import 'package:flutter_test/flutter_test.dart';
import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';

void main() {
  group('AchievementModel с type (как пишет репозиторий после фикса)', () {
    test('fromJson восстанавливает enum по @JsonValue', () {
      final m = AchievementModel.fromJson({
        'type': 'first_step',
        'level': 1,
        'updatedAt': '2026-06-23T10:00:00.000',
      });
      expect(m.type, AchievementType.firstStep);
      expect(m.level, 1);
    });

    test('round-trip: toJson содержит type, fromJson читает обратно', () {
      const original =
          AchievementModel(type: AchievementType.masterConjugator, level: 3);
      final restored = AchievementModel.fromJson(original.toJson());
      expect(restored.type, AchievementType.masterConjugator);
      expect(restored.level, 3);
    });
  });

  group('UserLanguageProgressModel с непустыми achievements', () {
    test('парсится без краша, когда у достижений есть type', () {
      // Документ languages/{langId} после _preprocessProgressData:
      // type уже подставлен (из записи репозитория или из ключа при чтении).
      final doc = <String, dynamic>{
        'id': 'fr',
        'lastLesson': 'lesson_01',
        'lastParagraph': 2,
        'achievements': {
          'first_step': {
            'type': 'first_step',
            'level': 1,
            'updatedAt': '2026-06-23T10:00:00.000',
          },
          'vocabulary_master': {
            'type': 'vocabulary_master',
            'level': 2,
            'updatedAt': '2026-06-23T11:00:00.000',
          },
        },
      };

      final model = UserLanguageProgressModel.fromJson(doc);
      expect(model.achievements.length, 2);
      expect(model.achievements['first_step']!.type, AchievementType.firstStep);
      expect(model.achievements['vocabulary_master']!.level, 2);
    });
  });
}
