// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_task_model.freezed.dart';
part 'image_task_model.g.dart';

/// Задание шага "описание картинки" урока (Lesson Matrix §A) — картинка +
/// список пунктов, которые нужно раскрыть в описании. Пункты — та же форма,
/// что и `points` в FreePracticeTaskModel (список текстов по коду языка
/// интерфейса).
@freezed
abstract class ImageTaskModel with _$ImageTaskModel {
  const factory ImageTaskModel({
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'points_to_describe')
    @Default(<Map<String, dynamic>>[])
    List<Map<String, dynamic>> pointsToDescribe,
  }) = _ImageTaskModel;

  factory ImageTaskModel.fromJson(Map<String, dynamic> json) =>
      _$ImageTaskModelFromJson(json);
}
