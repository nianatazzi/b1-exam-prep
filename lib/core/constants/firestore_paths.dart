abstract class FirestorePaths {
  // Корневые коллекции
  static const String basic = 'basic';
  static const String privateUserInfo = 'private_user_info';
  static const String publicUserInfo = 'public_user_info';

  // Учебный контент
  static String language(String langId) => '$basic/$langId';
  static String lessons(String langId) => '$basic/$langId/lessons';
  static String lesson(String langId, String lessonId) =>
      '$basic/$langId/lessons/$lessonId';
  static String theory(String langId, String lessonId) =>
      '$basic/$langId/lessons/$lessonId/theory';
  static String additional(String langId, String lessonId) =>
      '$basic/$langId/lessons/$lessonId/additional';
  static String exercises(String langId) => '$basic/$langId/exercises';
  static String theoryChunks(String langId) => '$basic/$langId/theory_chunks';

  // Служебные документы (заглушки для будущих фич)
  static String serviceBasicVocabulary(String langId) =>
      '$basic/$langId/service/basic_vocabulary';

  // Приватные данные пользователя
  static String privateUser(String userId) => '$privateUserInfo/$userId';
  static String friends(String userId) => '$privateUserInfo/$userId/friends';
  static String userLanguages(String userId) =>
      '$privateUserInfo/$userId/languages';
  static String userLanguage(String userId, String langId) =>
      '$privateUserInfo/$userId/languages/$langId';
  static String userVocabulary(String userId, String langId) =>
      '$privateUserInfo/$userId/languages/$langId/user_vocabulary';

  // Публичный профиль
  static String publicUser(String userId) => '$publicUserInfo/$userId';
}
