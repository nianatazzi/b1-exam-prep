// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_user_model.freezed.dart';
part 'public_user_model.g.dart';

@freezed
abstract class PublicUserModel with _$PublicUserModel {
  const factory PublicUserModel({
    // id берётся из DocumentSnapshot.id — не хранится в теле документа
    @JsonKey(includeToJson: false) required String id,
    required String name,
    required String surname,
    String? avatar,
    required int points,
    @Default(<String, dynamic>{}) Map<String, dynamic> preference,
    @Default(false) bool onboardingComplete,
  }) = _PublicUserModel;

  factory PublicUserModel.fromJson(Map<String, dynamic> json) =>
      _$PublicUserModelFromJson(json);
}
