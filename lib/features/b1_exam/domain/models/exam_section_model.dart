// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_section_model.freezed.dart';
part 'exam_section_model.g.dart';

enum ExamSectionType {
  @JsonValue('image_description')
  imageDescription,
  @JsonValue('monologue')
  monologue,
  @JsonValue('dialogue')
  dialogue;

  /// Разбор строкового ключа раздела в тип. Нужен на границе маршрута:
  /// GoRouter отдаёт sectionId строкой, а ExamSectionModel ниже B1HomeScreen
  /// не загружается — ни TopicDetail, ни Practice, ни ImagePractice его не читают.
  /// null — раздела с таким ключом нет (битый маршрут или новый тип в Firestore).
  static ExamSectionType? fromKey(String key) {
    for (final entry in _$ExamSectionTypeEnumMap.entries) {
      if (entry.value == key) return entry.key;
    }
    return null;
  }
}

extension ExamSectionTypeKey on ExamSectionType {
  /// Строковый ключ раздела (= JsonValue = id документа в Firestore).
  /// Единственный источник — сгенерированная `_$ExamSectionTypeEnumMap`,
  /// без ручных switch-копий. Использовать только его, не `.name`:
  /// `.name` даёт `imageDescription`, а в базе лежит `image_description`.
  String get key => _$ExamSectionTypeEnumMap[this]!;
}

@freezed
abstract class ExamSectionModel with _$ExamSectionModel {
  const factory ExamSectionModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 's_id') required int sId,
    required ExamSectionType type,
    required String title,
    @Default('') String description,
    @Default('') String icon,
  }) = _ExamSectionModel;

  factory ExamSectionModel.fromJson(Map<String, dynamic> json) =>
      _$ExamSectionModelFromJson(json);
}
