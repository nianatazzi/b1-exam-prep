// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'additional_model.freezed.dart';
part 'additional_model.g.dart';

@freezed
abstract class AdditionalModel with _$AdditionalModel {
  const factory AdditionalModel({
    @JsonKey(includeToJson: false) required String id,
    required String type,
    required String title,
    required String content,
  }) = _AdditionalModel;

  factory AdditionalModel.fromJson(Map<String, dynamic> json) =>
      _$AdditionalModelFromJson(json);
}
