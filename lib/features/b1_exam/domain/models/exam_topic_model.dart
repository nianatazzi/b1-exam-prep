// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_topic_model.freezed.dart';
part 'exam_topic_model.g.dart';

@freezed
abstract class ExamTopicModel with _$ExamTopicModel {
  const factory ExamTopicModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 't_id') required int tId,
    required String title,
    @Default('') String description,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _ExamTopicModel;

  factory ExamTopicModel.fromJson(Map<String, dynamic> json) =>
      _$ExamTopicModelFromJson(json);
}
