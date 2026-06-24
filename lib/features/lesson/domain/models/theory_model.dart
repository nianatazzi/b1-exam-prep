// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theory_model.freezed.dart';
part 'theory_model.g.dart';

@freezed
abstract class TheoryModel with _$TheoryModel {
  const factory TheoryModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'th_id') required int thId,
    required String topic,
    required String title,
    required String text,
    String? video,
    @Default(0) int duration,
    @Default(0) int reward,
  }) = _TheoryModel;

  factory TheoryModel.fromJson(Map<String, dynamic> json) =>
      _$TheoryModelFromJson(json);
}
