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
  static String lexicalSet(String langId, String lessonId) =>
      '$basic/$langId/lessons/$lessonId/lexical_set';
  static String verbs(String langId, String lessonId) =>
      '$basic/$langId/lessons/$lessonId/verbs';
  static String additional(String langId, String lessonId) =>
      '$basic/$langId/lessons/$lessonId/additional';
  static String theoryChunks(String langId) => '$basic/$langId/theory_chunks';

  // Упражнения — корневая коллекция (не вложена в basic/)
  static const String exercises = 'exercises';

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

  // B1 Polish exam prep
  static const String b1Polish = 'b1_polish';
  static const String b1CourseId = 'b1_pl';

  static const String b1Sections = '$b1Polish/sections';
  static String b1Section(String sectionId) => '$b1Sections/$sectionId';
  static String b1Topics(String sectionId) =>
      '$b1Sections/$sectionId/topics';
  static String b1Topic(String sectionId, String topicId) =>
      '$b1Sections/$sectionId/topics/$topicId';
  static String b1Vocabulary(String sectionId, String topicId) =>
      '${b1Topic(sectionId, topicId)}/vocabulary';
  static String b1Grammar(String sectionId, String topicId) =>
      '${b1Topic(sectionId, topicId)}/grammar';
  static String b1Phrases(String sectionId, String topicId) =>
      '${b1Topic(sectionId, topicId)}/phrases';

  // B1 progress
  static String b1Progress(String userId) =>
      '$privateUserInfo/$userId/b1_progress/pl';
}
