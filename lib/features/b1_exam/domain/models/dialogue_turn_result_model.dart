// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialogue_turn_result_model.freezed.dart';
part 'dialogue_turn_result_model.g.dart';

/// Ответ Cloud Function continueDialogue на один ход (дизайн диалога,
/// "Function contract").
@freezed
abstract class DialogueTurnResultModel with _$DialogueTurnResultModel {
  const factory DialogueTurnResultModel({
    @Default('') String reply,
    @JsonKey(name: 'turnsLeft') @Default(0) int turnsLeft,
    @JsonKey(name: 'shouldClose') @Default(false) bool shouldClose,
  }) = _DialogueTurnResultModel;

  factory DialogueTurnResultModel.fromJson(Map<String, dynamic> json) =>
      _$DialogueTurnResultModelFromJson(json);
}
