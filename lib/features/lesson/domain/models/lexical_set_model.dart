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
    required String translation,
    required String transcription,
    @JsonKey(name: 'set_title') required String setTitle,
    required int reward,
  }) = _LexicalSetModel;

  factory LexicalSetModel.fromJson(Map<String, dynamic> json) =>
      _$LexicalSetModelFromJson(json);
}
