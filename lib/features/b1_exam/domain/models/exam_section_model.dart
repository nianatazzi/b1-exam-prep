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
  dialogue,
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
