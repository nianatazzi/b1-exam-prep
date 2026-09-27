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

  // B1 exam prep — многоязычный контент (ARCHITECTURE.md §12.1). Раньше
  // b1_polish/pl/... (только польский) — переименовано и разложено по
  // langId (pl/fr/es/en/de, StudyLanguage.name).
  static const String b1ExamContent = 'b1_exam_content';
  static String b1CourseId(String langId) => 'b1_$langId';

  // B1 progress — раньше жёстко b1_progress/pl, теперь по langId, тот же
  // паттерн, что private_user_info/{userId}/languages/{langId} у linguobyte.
  static String b1Progress(String userId, String langId) =>
      '$privateUserInfo/$userId/b1_progress/$langId';

  // Lesson Matrix — лексические темы (Lesson Matrix §A)
  static String b1LexicalTopics(String langId) =>
      '$b1ExamContent/$langId/lexical_topics';
  static String b1LexicalTopic(String langId, String lexicalTopicId) =>
      '${b1LexicalTopics(langId)}/$lexicalTopicId';
  static String b1LexicalVocabulary(String langId, String lexicalTopicId) =>
      '${b1LexicalTopic(langId, lexicalTopicId)}/vocabulary';

  // Lesson Matrix — грамматические темы
  static String b1GrammarTopics(String langId) =>
      '$b1ExamContent/$langId/grammar_topics';
  static String b1GrammarTopic(String langId, String grammarTopicId) =>
      '${b1GrammarTopics(langId)}/$grammarTopicId';
  static String b1GrammarTopicRules(String langId, String grammarTopicId) =>
      '${b1GrammarTopic(langId, grammarTopicId)}/rules';

  // Lesson Matrix — уроки (пара лексической + грамматической темы)
  static String b1Lessons(String langId) => '$b1ExamContent/$langId/lessons';
  static String b1Lesson(String langId, String lessonId) =>
      '${b1Lessons(langId)}/$lessonId';

  // Серверная конфигурация (Admin SDK-only, Cloud Functions) — НОВАЯ
  // отдельная root-коллекция, не подколлекция b1ExamContent: llmConfig/
  // llmQuota общие для всех языков, не привязаны к конкретному langId.
  static const String b1Service = 'b1_service';
  static const String b1LlmConfig = '$b1Service/llmConfig';
  static String b1LlmQuota(String userId) => '$b1Service/llmQuota/$userId';
}
