abstract class AvatarPresets {
  static const String _dir = 'assets/images/avatars';

  static const List<String> ids = [
    'avatar_01', 'avatar_02', 'avatar_03', 'avatar_04',
    'avatar_05', 'avatar_06', 'avatar_07', 'avatar_08',
    'avatar_09', 'avatar_10', 'avatar_11', 'avatar_12',
  ];

  /// Аватар по умолчанию (выбран при открытии онбординга).
  static const String defaultId = 'avatar_01';

  static String pathOf(String id) => '$_dir/$id.png';
}
