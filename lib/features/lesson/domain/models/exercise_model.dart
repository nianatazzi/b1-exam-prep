// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

@freezed
abstract class ExerciseModel with _$ExerciseModel {
  const factory ExerciseModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'ex_id') required int exId,
    required String type,
    @JsonKey(name: 'segment_type') required String segmentType,
    // null для vocab-упражнений (lexical_set не имеет linked_item_id)
    @JsonKey(name: 'linked_item_id') int? linkedItemId,
    @JsonKey(name: 'type_data') Map<String, dynamic>? typeData,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
}
