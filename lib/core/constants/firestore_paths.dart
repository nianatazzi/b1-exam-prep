abstract class FirestorePaths {
  // Корневые коллекции
  static const String privateUserInfo = 'private_user_info';
  static const String publicUserInfo = 'public_user_info';

  // Упражнения — корневая коллекция, общая с linguobyte (course_id разделяет)
  static const String exercises = 'exercises';

  // Приватные данные пользователя
  static String privateUser(String userId) => '$privateUserInfo/$userId';

  // Публичный профиль
  static String publicUser(String userId) => '$publicUserInfo/$userId';

  // B1 Polish exam prep
  static const String b1Polish = 'b1_polish';
  static const String b1CourseId = 'b1_pl';

  // 'pl' — документ языка внутри b1_polish (аналог структуры b1Progress ниже)
  static const String b1Sections = '$b1Polish/pl/sections';
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
