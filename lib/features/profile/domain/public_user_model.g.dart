// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublicUserModel _$PublicUserModelFromJson(Map<String, dynamic> json) =>
    _PublicUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      avatar: json['avatar'] as String?,
      points: (json['points'] as num).toInt(),
      preference:
          json['preference'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );

Map<String, dynamic> _$PublicUserModelToJson(_PublicUserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'avatar': instance.avatar,
      'points': instance.points,
      'preference': instance.preference,
    };
