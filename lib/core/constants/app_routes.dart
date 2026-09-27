abstract class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // B1 exam prep — langId (StudyLanguage.name) в пути: гарантирует, что
  // lexicalTopicId/lessonId читаются из того же языкового документа, что
  // и на экране, откуда сделан переход, даже если язык обучения сменили
  // (Settings) в другой вкладке/окне посреди навигации (ARCHITECTURE.md §12.1).
  static const String b1Home = '/b1';
  static const String b1LexicalTopic = '/b1/:langId/topic/:lexicalTopicId';
  static const String b1Lesson = '/b1/:langId/lesson/:lessonId';
  static const String b1Dialogue = '/b1/:langId/lesson/:lessonId/dialogue';

  static String b1LexicalTopicPath(String langId, String lexicalTopicId) =>
      '/b1/$langId/topic/$lexicalTopicId';
  static String b1LessonPath(String langId, String lessonId) =>
      '/b1/$langId/lesson/$lessonId';
  static String b1DialoguePath(String langId, String lessonId) =>
      '/b1/$langId/lesson/$lessonId/dialogue';
}
