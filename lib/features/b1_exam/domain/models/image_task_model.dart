// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_task_model.freezed.dart';
part 'image_task_model.g.dart';

/// Задание шага "описание картинки" урока (Lesson Matrix §A) — картинка.
/// `points_to_describe` в документе есть, но в клиент не мапится: пункты не
/// показываются студенту, их читает только Cloud Function analyzeSpeech
/// напрямую из Firestore для сверки в LLM-анализе (extractTaskPoints).
@freezed
abstract class ImageTaskModel with _$ImageTaskModel {
  const factory ImageTaskModel({
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
  }) = _ImageTaskModel;

  factory ImageTaskModel.fromJson(Map<String, dynamic> json) =>
      _$ImageTaskModelFromJson(json);
}
