// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lexical_set_model.freezed.dart';
part 'lexical_set_model.g.dart';

@freezed
abstract class LexicalSetModel with _$LexicalSetModel {
  const factory LexicalSetModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'voc_id') required int vocId,
    required String title,
    @Default('') String translation,
    @Default('') String transcription,
    @JsonKey(name: 'set_title') @Default('') String setTitle,
    @Default(0) int reward,
  }) = _LexicalSetModel;

  factory LexicalSetModel.fromJson(Map<String, dynamic> json) =>
      _$LexicalSetModelFromJson(json);
}
