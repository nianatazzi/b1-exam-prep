// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'verb_model.freezed.dart';
part 'verb_model.g.dart';

@freezed
abstract class VerbModel with _$VerbModel {
  const factory VerbModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'v_id') required int vId,
    required String title,
    required String type,
    required Map<String, dynamic> conjugation,
    required Map<String, dynamic> translation,
    required Map<String, dynamic> transcription,
  }) = _VerbModel;

  factory VerbModel.fromJson(Map<String, dynamic> json) =>
      _$VerbModelFromJson(json);
}
