// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_vocabulary_model.freezed.dart';
part 'topic_vocabulary_model.g.dart';

@freezed
abstract class TopicVocabularyModel with _$TopicVocabularyModel {
  const factory TopicVocabularyModel({
    @JsonKey(includeToJson: false) required String id,
    @JsonKey(name: 'voc_id') required int vocId,
    required String word,
    @Default(<String, dynamic>{}) Map<String, dynamic> translation,
    @Default('') String transcription,
    String? gender,
    @JsonKey(name: 'example_sentence')
    @Default(<String, dynamic>{})
    Map<String, dynamic> exampleSentence,
    @JsonKey(name: 'audio_url') String? audioUrl,
  }) = _TopicVocabularyModel;

  factory TopicVocabularyModel.fromJson(Map<String, dynamic> json) =>
      _$TopicVocabularyModelFromJson(json);
}
