// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_task_model.dart';

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
    // Задание свободной практики; заполняется только для monologue.
    // null и для image_description (там задание — картинка темы), и для тем,
    // где свободной практики нет вовсе.
    @JsonKey(name: 'free_practice_task') FreePracticeTaskModel? freePracticeTask,
  }) = _ExamTopicModel;

  factory ExamTopicModel.fromJson(Map<String, dynamic> json) =>
      _$ExamTopicModelFromJson(json);
}
