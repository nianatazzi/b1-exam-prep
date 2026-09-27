// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'free_practice_task_model.freezed.dart';
part 'free_practice_task_model.g.dart';

/// Задание свободной практики для раздела monologue: формулировка темы —
/// аналог экзаменационной карточки B1. В image_description роль задания
/// играет картинка темы (`image_url`), поэтому там это поле не заполняется
/// (см. ARCHITECTURE.md §6.2).
///
/// `prompt` — текст по коду языка интерфейса, та же форма, что у
/// `explanation` в GrammarRuleModel. С дефолтом: наполовину заполненный
/// контент-документ не должен ронять разбор всего списка тем в `getTopics()`.
///
/// `points` в документе есть, но в клиент не мапится: пункты не показываются
/// студенту, их читает только Cloud Function analyzeSpeech напрямую из
/// Firestore для сверки в LLM-анализе (extractTaskPoints).
///
/// `durationSeconds`/`thinkSeconds` — nullable, а не с числовым дефолтом:
/// null означает «в контенте не задано». Значение по умолчанию подставляет
/// presentation-слой из AppConstants, чтобы бизнес-порог жил в одном месте
/// (ARCHITECTURE.md §15), а не дублировался в модели.
@freezed
abstract class FreePracticeTaskModel with _$FreePracticeTaskModel {
  const factory FreePracticeTaskModel({
    @Default(<String, dynamic>{}) Map<String, dynamic> prompt,
    @JsonKey(name: 'duration_seconds') int? durationSeconds,
    @JsonKey(name: 'think_seconds') int? thinkSeconds,
  }) = _FreePracticeTaskModel;

  factory FreePracticeTaskModel.fromJson(Map<String, dynamic> json) =>
      _$FreePracticeTaskModelFromJson(json);
}
