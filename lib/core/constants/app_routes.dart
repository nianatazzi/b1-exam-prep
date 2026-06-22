abstract class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String profile = '/profile';

  // Урок: langId и lessonId передаются явно, чтобы LessonScreen
  // не зависел от HomeNotifier для определения языка обучения
  static const String lesson = '/lesson/:langId/:lessonId';

  static const String settings = '/settings';
  static const String result = '/result';

  static String lessonPath(String langId, String lessonId) =>
      '/lesson/$langId/$lessonId';
}
