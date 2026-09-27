// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageTaskModel _$ImageTaskModelFromJson(Map<String, dynamic> json) =>
    _ImageTaskModel(
      imageUrl: json['image_url'] as String? ?? '',
      pointsToDescribe:
          (json['points_to_describe'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const <Map<String, dynamic>>[],
    );

Map<String, dynamic> _$ImageTaskModelToJson(_ImageTaskModel instance) =>
    <String, dynamic>{
      'image_url': instance.imageUrl,
      'points_to_describe': instance.pointsToDescribe,
    };
