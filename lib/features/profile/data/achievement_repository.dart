import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/repositories/i_achievement_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'achievement_repository.g.dart';

@riverpod
AchievementRepository achievementRepository(Ref ref) =>
    AchievementRepository(FirebaseFirestore.instance);

class AchievementRepository implements IAchievementRepository {
  final FirebaseFirestore _firestore;

  const AchievementRepository(this._firestore);

  @override
  Future<void> updateAchievement({
    required String userId,
    required String langId,
    required AchievementType type,
    required int newLevel,
  }) async {
    try {
      final key = _achievementKey(type);
      await _firestore
          .doc(FirestorePaths.userLanguage(userId, langId))
          .update({
        'achievements.$key': {
          // type хранится внутри документа, чтобы AchievementModel.fromJson
          // мог восстановить enum (иначе $enumDecode падает на null).
          'type': key,
          'level': newLevel,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      });
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  String _achievementKey(AchievementType type) => switch (type) {
        AchievementType.masterConjugator => 'master_conjugator',
        AchievementType.firstStep => 'first_step',
        AchievementType.focusedLearner => 'focused_learner',
        AchievementType.interestedLearner => 'interested_learner',
        AchievementType.vocabularyMaster => 'vocabulary_master',
      };
}
