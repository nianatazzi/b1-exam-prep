// Регресс-тест: достижения не роняют парсинг прогресса.
// Без type в документе AchievementModel.fromJson падает на ArgumentError,
// и getProgress отдавал бы UnknownError → ProfileScreen в error.
import 'package:flutter_test/flutter_test.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';

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

  group('TopicProgressModel с непустыми achievements', () {
    test('парсится без краша, когда у достижений есть type', () {
      // Документ b1_progress/{userId} после _preprocessProgressData:
      // type уже подставлен (из записи репозитория или из ключа при чтении).
      final doc = <String, dynamic>{
        'id': 'u1',
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

      final model = TopicProgressModel.fromJson(doc);
      expect(model.achievements.length, 2);
      expect(model.achievements['first_step']!.type, AchievementType.firstStep);
      expect(model.achievements['vocabulary_master']!.level, 2);
    });
  });
}
