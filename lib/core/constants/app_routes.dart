abstract class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String profile = '/profile';

  // Урок и вложенный флоу: Theory → Practice → Additional
  static const String lesson = '/lesson/:lessonId';
  static const String theory = 'theory';
  static const String practice = 'practice';
  static const String additional = 'additional';

  // Хелпер для навигации на конкретный урок
  static String lessonPath(String lessonId) => '/lesson/$lessonId';
}
