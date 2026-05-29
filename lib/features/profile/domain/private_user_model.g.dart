// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    _SubscriptionModel(
      plan: $enumDecode(_$SubscriptionPlanEnumMap, json['plan']),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$SubscriptionModelToJson(_SubscriptionModel instance) =>
    <String, dynamic>{
      'plan': _$SubscriptionPlanEnumMap[instance.plan]!,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$SubscriptionPlanEnumMap = {
  SubscriptionPlan.free: 'free',
  SubscriptionPlan.premium: 'premium',
};

_PrivateUserModel _$PrivateUserModelFromJson(Map<String, dynamic> json) =>
    _PrivateUserModel(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      subscription: SubscriptionModel.fromJson(
        json['subscription'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PrivateUserModelToJson(_PrivateUserModel instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'email': instance.email,
      'phone': instance.phone,
      'subscription': instance.subscription,
    };
