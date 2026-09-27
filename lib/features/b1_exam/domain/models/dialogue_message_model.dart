// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialogue_message_model.freezed.dart';
part 'dialogue_message_model.g.dart';

enum DialogueRole {
  @JsonValue('user')
  user,
  @JsonValue('ai')
  ai,
}

/// Одна реплика диалога (Lesson Matrix, дизайн диалога) — история хода
/// хранится на клиенте (DialogueNotifier) и целиком пересылается на каждый
/// ход в continueDialogue; та же форма сохраняется в lessonResults как
/// turns при завершении шага.
@freezed
abstract class DialogueMessageModel with _$DialogueMessageModel {
  const factory DialogueMessageModel({
    required DialogueRole role,
    required String text,
  }) = _DialogueMessageModel;

  factory DialogueMessageModel.fromJson(Map<String, dynamic> json) =>
      _$DialogueMessageModelFromJson(json);
}
