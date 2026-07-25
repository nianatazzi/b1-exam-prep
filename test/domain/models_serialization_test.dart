// Страховочная сетка: фиксирует контракт сериализации с Firestore —
// snake_case ключи и поведение @Default.
import 'package:flutter_test/flutter_test.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/features/profile/domain/private_user_model.dart';
import 'package:b1_exam_prep/features/profile/domain/public_user_model.dart';

void main() {
  group('snake_case ключи Firestore', () {
    test('ExerciseModel читает ex_id / segment_type / linked_item_id / '
        'grammar_types / type_data', () {
      final m = ExerciseModel.fromJson({
        'id': 'doc1',
        'ex_id': 5,
        'type': 'fill_blank',
        'segment_type': 'grammar',
        'linked_item_id': 2,
        'grammar_types': ['grammar'],
        'type_data': {'form': 'a [] b'},
      });
      expect(m.exId, 5);
      expect(m.segmentType, 'grammar');
      expect(m.linkedItemId, 2);
      expect(m.grammarTypes, ['grammar']);
      expect(m.typeData?['form'], 'a [] b');
    });
  });

  group('@Default при частичном документе', () {
    test('TopicProgressModel: пустые stats/topicResults/achievements '
        '→ дефолты, без краша', () {
      final m = TopicProgressModel.fromJson({'id': 'u1'});
      expect(m.topicResults, isEmpty);
      expect(m.achievements, isEmpty);
      expect(m.stats.grammar.total, 0);
      expect(m.stats.speaking.percent, 0);
    });

    test('TopicProgressModel читает topicResults и stats', () {
      final m = TopicProgressModel.fromJson({
        'id': 'u1',
        'stats': {
          'vocabulary': {'correct': 4, 'total': 5},
        },
        'topicResults': {
          'image_description_1_vocabulary': {
            'correct': 3,
            'total': 4,
            'firstAttempt': false,
          },
        },
      });
      expect(m.stats.vocabulary.percent, 80);
      expect(m.topicResults['image_description_1_vocabulary']!.correct, 3);
      expect(
        m.topicResults['image_description_1_vocabulary']!.incorrectExerciseIds,
        isEmpty,
      );
    });

    test('PublicUserModel: отсутствующий preference → пустая map', () {
      final m = PublicUserModel.fromJson({
        'id': 'u1', 'name': 'A', 'surname': 'B', 'points': 10,
      });
      expect(m.preference, isEmpty);
      expect(m.avatar, isNull);
    });
  });

  group('Терпимость приватного профиля', () {
    test('PrivateUserModel без subscription/phone/deviceId → дефолты '
        '(план free), не падает', () {
      final m = PrivateUserModel.fromJson({
        'id': 'u1', 'email': 'a@b.c',
      });
      expect(m.subscription.plan, SubscriptionPlan.free);
      expect(m.phone, '');
      expect(m.deviceId, '');
    });

    test('SubscriptionModel с неизвестным plan → free', () {
      final m = SubscriptionModel.fromJson({'plan': 'enterprise'});
      expect(m.plan, SubscriptionPlan.free);
    });
  });
}
