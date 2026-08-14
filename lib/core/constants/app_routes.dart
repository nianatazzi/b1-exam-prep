abstract class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // B1 exam prep
  static const String b1Home = '/b1';
  static const String b1Topic = '/b1/topic/:sectionId/:topicId';
  static const String b1Practice =
      '/b1/practice/:sectionId/:topicId/:prepLevel';
  static const String b1ImagePractice =
      '/b1/image-practice/:sectionId/:topicId';

  static String b1TopicPath(String sectionId, String topicId) =>
      '/b1/topic/$sectionId/$topicId';
  static String b1PracticePath(
    String sectionId,
    String topicId,
    String prepLevel,
  ) =>
      '/b1/practice/$sectionId/$topicId/$prepLevel';
  static String b1ImagePracticePath(String sectionId, String topicId) =>
      '/b1/image-practice/$sectionId/$topicId';
}
