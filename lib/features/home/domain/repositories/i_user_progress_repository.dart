import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';

abstract class IUserProgressRepository {
  Future<UserLanguageProgressModel?> getUserLanguageProgress(
    String userId,
    String langId,
  );

  Future<void> updateProgress(
    String userId,
    String langId,
    String lastLesson,
    int lastParagraph,
  );
}
