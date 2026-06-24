// Страховочная сетка (волна 0): фиксирует контракт сериализации с Firestore —
// snake_case ключи и поведение @Default. Волна 1 правит обязательность полей;
// эти ключи и дефолты меняться не должны.
import 'package:flutter_test/flutter_test.dart';
import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/lexical_set_model.dart';
import 'package:linguobyte/features/lesson/domain/models/theory_model.dart';
import 'package:linguobyte/features/lesson/domain/models/verb_model.dart';
import 'package:linguobyte/features/profile/domain/private_user_model.dart';
import 'package:linguobyte/features/profile/domain/public_user_model.dart';

void main() {
  group('snake_case ключи Firestore', () {
    test('ExerciseModel читает ex_id / segment_type / linked_item_id / '
        'grammar_types / type_data', () {
      final m = ExerciseModel.fromJson({
        'id': 'doc1',
        'ex_id': 5,
        'type': 'fill_blank',
        'segment_type': 'theory',
        'linked_item_id': 2,
        'grammar_types': ['grammar'],
        'type_data': {'form': 'a [] b'},
      });
      expect(m.exId, 5);
      expect(m.segmentType, 'theory');
      expect(m.linkedItemId, 2);
      expect(m.grammarTypes, ['grammar']);
      expect(m.typeData?['form'], 'a [] b');
    });

    test('TheoryModel.th_id, LexicalSetModel.voc_id/set_title, VerbModel.v_id, '
        'LessonModel.l_id', () {
      expect(
        TheoryModel.fromJson({
          'id': 't', 'th_id': 3, 'topic': 'x', 'title': 'y',
          'text': 'z', 'duration': 1, 'reward': 0,
        }).thId,
        3,
      );
      final lex = LexicalSetModel.fromJson({
        'id': 'l', 'voc_id': 7, 'title': 'a', 'translation': 'b',
        'transcription': 'c', 'set_title': 'Topic', 'reward': 0,
      });
      expect(lex.vocId, 7);
      expect(lex.setTitle, 'Topic');
      expect(
        VerbModel.fromJson({
          'id': 'v', 'v_id': 9, 'title': 't', 'type': 'r',
          'conjugation': <String, dynamic>{},
          'translation': <String, dynamic>{},
          'transcription': <String, dynamic>{},
        }).vId,
        9,
      );
      expect(
        LessonModel.fromJson({'id': 'les', 'l_id': 4, 'theme': 'Theme'}).lId,
        4,
      );
    });

    test('id берётся из переданного json (DocumentSnapshot.id), '
        'toJson его не включает', () {
      final m = LessonModel.fromJson({'id': 'les01', 'l_id': 1, 'theme': 'T'});
      expect(m.id, 'les01');
      expect(m.toJson().containsKey('id'), isFalse);
    });
  });

  group('@Default при частичном документе', () {
    test('UserLanguageProgressModel: пустые stats/stepResults/achievements '
        '→ дефолты, без краша', () {
      final m = UserLanguageProgressModel.fromJson({
        'id': 'fr',
        'lastLesson': 'lesson_01',
        'lastParagraph': 0,
      });
      expect(m.stepResults, isEmpty);
      expect(m.achievements, isEmpty);
      expect(m.stats.grammar.total, 0);
      expect(m.stats.speaking.percent, 0);
    });

    test('UserLanguageProgressModel читает stepResults и stats', () {
      final m = UserLanguageProgressModel.fromJson({
        'id': 'fr',
        'lastLesson': 'lesson_01',
        'lastParagraph': 2,
        'stats': {
          'vocabulary': {'correct': 4, 'total': 5},
        },
        'stepResults': {
          '1_theory_1': {'correct': 3, 'total': 4, 'firstAttempt': false},
        },
      });
      expect(m.stats.vocabulary.percent, 80);
      expect(m.stepResults['1_theory_1']!.correct, 3);
      expect(m.stepResults['1_theory_1']!.incorrectExerciseIds, isEmpty);
    });

    test('PublicUserModel: отсутствующий preference → пустая map', () {
      final m = PublicUserModel.fromJson({
        'id': 'u1', 'name': 'A', 'surname': 'B', 'points': 10,
      });
      expect(m.preference, isEmpty);
      expect(m.avatar, isNull);
    });
  });

  group('Волна 1.3: терпимость к пропущенным полям контента', () {
    test('TheoryModel без duration/reward → дефолты, не падает', () {
      final m = TheoryModel.fromJson({
        'id': 't', 'th_id': 1, 'topic': 'x', 'title': 'y', 'text': 'z',
      });
      expect(m.duration, 0);
      expect(m.reward, 0);
    });

    test('LexicalSetModel без translation/transcription/set_title/reward '
        '→ дефолты', () {
      final m = LexicalSetModel.fromJson({
        'id': 'l', 'voc_id': 1, 'title': 'word',
      });
      expect(m.translation, '');
      expect(m.transcription, '');
      expect(m.setTitle, '');
      expect(m.reward, 0);
    });

    test('VerbModel без type/conjugation/translation/transcription → дефолты', () {
      final m = VerbModel.fromJson({
        'id': 'v', 'v_id': 1, 'title': 'go',
      });
      expect(m.type, '');
      expect(m.conjugation, isEmpty);
      expect(m.translation, isEmpty);
      expect(m.transcription, isEmpty);
    });
  });

  group('Волна 1.3: терпимость приватного профиля', () {
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
