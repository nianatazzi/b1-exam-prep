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
    // Неизвестное/отсутствующее значение плана трактуется как free,
    // чтобы частичный документ не ронял загрузку профиля.
    @JsonKey(unknownEnumValue: SubscriptionPlan.free)
    @Default(SubscriptionPlan.free)
    SubscriptionPlan plan,
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
    @Default('') String deviceId,
    @Default('') String email,
    @Default('') String phone,
    @Default(SubscriptionModel()) SubscriptionModel subscription,
    DateTime? lastActiveDate,
    @Default(0) int currentStreak,
    @Default(0) int bestStreak,
  }) = _PrivateUserModel;

  factory PrivateUserModel.fromJson(Map<String, dynamic> json) =>
      _$PrivateUserModelFromJson(json);
}
