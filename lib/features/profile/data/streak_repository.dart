import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/profile/domain/repositories/i_streak_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_repository.g.dart';

@riverpod
StreakRepository streakRepository(Ref ref) =>
    StreakRepository(FirebaseFirestore.instance);

class StreakRepository implements IStreakRepository {
  final FirebaseFirestore _firestore;

  const StreakRepository(this._firestore);

  @override
  Future<int> updateStreak(String userId) async {
    try {
      final docRef = _firestore.doc(FirestorePaths.privateUser(userId));
      final doc = await docRef.get();
      final data = doc.data() ?? {};

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final lastActiveRaw = data['lastActiveDate'];
      DateTime? lastActive;
      if (lastActiveRaw is Timestamp) {
        lastActive = lastActiveRaw.toDate();
      }

      final lastActiveDay = lastActive != null
          ? DateTime(lastActive.year, lastActive.month, lastActive.day)
          : null;

      // Уже отмечен сегодня — ничего не делаем
      if (lastActiveDay != null && lastActiveDay == today) {
        return (data['currentStreak'] as int?) ?? 1;
      }

      final yesterday = today.subtract(const Duration(days: 1));
      final currentStreak = (data['currentStreak'] as int?) ?? 0;
      final bestStreak = (data['bestStreak'] as int?) ?? 0;

      final int newStreak;
      if (lastActiveDay == yesterday) {
        newStreak = currentStreak + 1;
      } else {
        newStreak = 1;
      }

      final newBest = newStreak > bestStreak ? newStreak : bestStreak;

      // set(merge:true) — top-level поля, безопасно создаёт документ если нет
      await docRef.set(
        {
          'lastActiveDate': Timestamp.fromDate(today),
          'currentStreak': newStreak,
          'bestStreak': newBest,
        },
        SetOptions(merge: true),
      );

      return newStreak;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
