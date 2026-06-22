// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'private_user_model.freezed.dart';
part 'private_user_model.g.dart';

// Закрытый список планов подписки из FIRESTORE.md
enum SubscriptionPlan {
  @JsonValue('free')
  free,
  @JsonValue('premium')
  premium,
}

@freezed
abstract class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    required SubscriptionPlan plan,
    // null для плана free
    DateTime? expiresAt,
  }) = _SubscriptionModel;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
}

@freezed
abstract class PrivateUserModel with _$PrivateUserModel {
  const factory PrivateUserModel({
    @JsonKey(includeToJson: false) required String id,
    required String deviceId,
    required String email,
    required String phone,
    required SubscriptionModel subscription,
    DateTime? lastActiveDate,
    @Default(0) int currentStreak,
    @Default(0) int bestStreak,
  }) = _PrivateUserModel;

  factory PrivateUserModel.fromJson(Map<String, dynamic> json) =>
      _$PrivateUserModelFromJson(json);
}
