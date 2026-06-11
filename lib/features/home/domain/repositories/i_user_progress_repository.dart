import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';

abstract class IUserProgressRepository {
  Future<UserLanguageProgressModel?> getUserLanguageProgress(
    String userId,
    String langId,
  );
}
