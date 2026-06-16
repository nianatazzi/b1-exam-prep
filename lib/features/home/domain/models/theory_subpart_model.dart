// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theory_subpart_model.freezed.dart';
part 'theory_subpart_model.g.dart';

// Упрощённая модель для HomeScreen — только отображение списка блоков теории.
// Полная модель (title, text, video, duration, reward) будет в Фазе 4.
@freezed
abstract class TheorySubpartModel with _$TheorySubpartModel {
  const factory TheorySubpartModel({
    // id берётся из DocumentSnapshot.id — не хранится в теле документа
    @JsonKey(includeToJson: false) required String id,
    required String topic,
  }) = _TheorySubpartModel;

  factory TheorySubpartModel.fromJson(Map<String, dynamic> json) =>
      _$TheorySubpartModelFromJson(json);
}
