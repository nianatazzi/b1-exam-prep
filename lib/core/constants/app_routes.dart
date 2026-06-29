abstract class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String profile = '/profile';

  // Урок: langId и lessonId передаются явно, чтобы LessonScreen
  // не зависел от HomeNotifier для определения языка обучения
  static const String lesson = '/lesson/:langId/:lessonId';

  static const String settings = '/settings';
  static const String result = '/result';

  static String lessonPath(String langId, String lessonId) =>
      '/lesson/$langId/$lessonId';

  // B1 exam prep
  static const String b1Home = '/b1';
  static const String b1Topic = '/b1/topic/:sectionId/:topicId';
  static const String b1Practice =
      '/b1/practice/:sectionId/:topicId/:prepLevel';

  static String b1TopicPath(String sectionId, String topicId) =>
      '/b1/topic/$sectionId/$topicId';
  static String b1PracticePath(
    String sectionId,
    String topicId,
    String prepLevel,
  ) =>
      '/b1/practice/$sectionId/$topicId/$prepLevel';
}
