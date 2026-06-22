// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'ex_id') int get exId; String get type;@JsonKey(name: 'segment_type') String get segmentType;@JsonKey(name: 'linked_item_id') int? get linkedItemId;@JsonKey(name: 'audio_url') String? get audioUrl;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'type_data') Map<String, dynamic>? get typeData;@JsonKey(name: 'grammar_types') List<String> get grammarTypes;
/// Create a copy of ExerciseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseModelCopyWith<ExerciseModel> get copyWith => _$ExerciseModelCopyWithImpl<ExerciseModel>(this as ExerciseModel, _$identity);

  /// Serializes this ExerciseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.exId, exId) || other.exId == exId)&&(identical(other.type, type) || other.type == type)&&(identical(other.segmentType, segmentType) || other.segmentType == segmentType)&&(identical(other.linkedItemId, linkedItemId) || other.linkedItemId == linkedItemId)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.typeData, typeData)&&const DeepCollectionEquality().equals(other.grammarTypes, grammarTypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,exId,type,segmentType,linkedItemId,audioUrl,imageUrl,const DeepCollectionEquality().hash(typeData),const DeepCollectionEquality().hash(grammarTypes));

@override
String toString() {
  return 'ExerciseModel(id: $id, exId: $exId, type: $type, segmentType: $segmentType, linkedItemId: $linkedItemId, audioUrl: $audioUrl, imageUrl: $imageUrl, typeData: $typeData, grammarTypes: $grammarTypes)';
}


}

/// @nodoc
abstract mixin class $ExerciseModelCopyWith<$Res>  {
  factory $ExerciseModelCopyWith(ExerciseModel value, $Res Function(ExerciseModel) _then) = _$ExerciseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'ex_id') int exId, String type,@JsonKey(name: 'segment_type') String segmentType,@JsonKey(name: 'linked_item_id') int? linkedItemId,@JsonKey(name: 'audio_url') String? audioUrl,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'type_data') Map<String, dynamic>? typeData,@JsonKey(name: 'grammar_types') List<String> grammarTypes
});




}
/// @nodoc
class _$ExerciseModelCopyWithImpl<$Res>
    implements $ExerciseModelCopyWith<$Res> {
  _$ExerciseModelCopyWithImpl(this._self, this._then);

  final ExerciseModel _self;
  final $Res Function(ExerciseModel) _then;

/// Create a copy of ExerciseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? exId = null,Object? type = null,Object? segmentType = null,Object? linkedItemId = freezed,Object? audioUrl = freezed,Object? imageUrl = freezed,Object? typeData = freezed,Object? grammarTypes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exId: null == exId ? _self.exId : exId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,segmentType: null == segmentType ? _self.segmentType : segmentType // ignore: cast_nullable_to_non_nullable
as String,linkedItemId: freezed == linkedItemId ? _self.linkedItemId : linkedItemId // ignore: cast_nullable_to_non_nullable
as int?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,typeData: freezed == typeData ? _self.typeData : typeData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,grammarTypes: null == grammarTypes ? _self.grammarTypes : grammarTypes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseModel].
extension ExerciseModelPatterns on ExerciseModel {
@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'ex_id')  int exId,  String type, @JsonKey(name: 'segment_type')  String segmentType, @JsonKey(name: 'linked_item_id')  int? linkedItemId, @JsonKey(name: 'audio_url')  String? audioUrl, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'type_data')  Map<String, dynamic>? typeData, @JsonKey(name: 'grammar_types')  List<String> grammarTypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseModel() when $default != null:
return $default(_that.id,_that.exId,_that.type,_that.segmentType,_that.linkedItemId,_that.audioUrl,_that.imageUrl,_that.typeData,_that.grammarTypes);case _:
  return orElse();

}
}

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'ex_id')  int exId,  String type, @JsonKey(name: 'segment_type')  String segmentType, @JsonKey(name: 'linked_item_id')  int? linkedItemId, @JsonKey(name: 'audio_url')  String? audioUrl, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'type_data')  Map<String, dynamic>? typeData, @JsonKey(name: 'grammar_types')  List<String> grammarTypes)  $default,) {final _that = this;
switch (_that) {
case _ExerciseModel():
return $default(_that.id,_that.exId,_that.type,_that.segmentType,_that.linkedItemId,_that.audioUrl,_that.imageUrl,_that.typeData,_that.grammarTypes);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'ex_id')  int exId,  String type, @JsonKey(name: 'segment_type')  String segmentType, @JsonKey(name: 'linked_item_id')  int? linkedItemId, @JsonKey(name: 'audio_url')  String? audioUrl, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'type_data')  Map<String, dynamic>? typeData, @JsonKey(name: 'grammar_types')  List<String> grammarTypes)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseModel() when $default != null:
return $default(_that.id,_that.exId,_that.type,_that.segmentType,_that.linkedItemId,_that.audioUrl,_that.imageUrl,_that.typeData,_that.grammarTypes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseModel implements ExerciseModel {
  const _ExerciseModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'ex_id') required this.exId, required this.type, @JsonKey(name: 'segment_type') required this.segmentType, @JsonKey(name: 'linked_item_id') this.linkedItemId, @JsonKey(name: 'audio_url') this.audioUrl, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'type_data') final  Map<String, dynamic>? typeData, @JsonKey(name: 'grammar_types') final  List<String> grammarTypes = const <String>[]}): _typeData = typeData, _grammarTypes = grammarTypes;
  factory _ExerciseModel.fromJson(Map<String, dynamic> json) => _$ExerciseModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'ex_id') final  int exId;
@override final  String type;
@override@JsonKey(name: 'segment_type') final  String segmentType;
@override@JsonKey(name: 'linked_item_id') final  int? linkedItemId;
@override@JsonKey(name: 'audio_url') final  String? audioUrl;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
 final  Map<String, dynamic>? _typeData;
@override@JsonKey(name: 'type_data') Map<String, dynamic>? get typeData {
  final value = _typeData;
  if (value == null) return null;
  if (_typeData is EqualUnmodifiableMapView) return _typeData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<String> _grammarTypes;
@override@JsonKey(name: 'grammar_types') List<String> get grammarTypes {
  if (_grammarTypes is EqualUnmodifiableListView) return _grammarTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grammarTypes);
}


/// Create a copy of ExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseModelCopyWith<_ExerciseModel> get copyWith => __$ExerciseModelCopyWithImpl<_ExerciseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.exId, exId) || other.exId == exId)&&(identical(other.type, type) || other.type == type)&&(identical(other.segmentType, segmentType) || other.segmentType == segmentType)&&(identical(other.linkedItemId, linkedItemId) || other.linkedItemId == linkedItemId)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._typeData, _typeData)&&const DeepCollectionEquality().equals(other._grammarTypes, _grammarTypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,exId,type,segmentType,linkedItemId,audioUrl,imageUrl,const DeepCollectionEquality().hash(_typeData),const DeepCollectionEquality().hash(_grammarTypes));

@override
String toString() {
  return 'ExerciseModel(id: $id, exId: $exId, type: $type, segmentType: $segmentType, linkedItemId: $linkedItemId, audioUrl: $audioUrl, imageUrl: $imageUrl, typeData: $typeData, grammarTypes: $grammarTypes)';
}


}

/// @nodoc
abstract mixin class _$ExerciseModelCopyWith<$Res> implements $ExerciseModelCopyWith<$Res> {
  factory _$ExerciseModelCopyWith(_ExerciseModel value, $Res Function(_ExerciseModel) _then) = __$ExerciseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'ex_id') int exId, String type,@JsonKey(name: 'segment_type') String segmentType,@JsonKey(name: 'linked_item_id') int? linkedItemId,@JsonKey(name: 'audio_url') String? audioUrl,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'type_data') Map<String, dynamic>? typeData,@JsonKey(name: 'grammar_types') List<String> grammarTypes
});




}
/// @nodoc
class __$ExerciseModelCopyWithImpl<$Res>
    implements _$ExerciseModelCopyWith<$Res> {
  __$ExerciseModelCopyWithImpl(this._self, this._then);

  final _ExerciseModel _self;
  final $Res Function(_ExerciseModel) _then;

/// Create a copy of ExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? exId = null,Object? type = null,Object? segmentType = null,Object? linkedItemId = freezed,Object? audioUrl = freezed,Object? imageUrl = freezed,Object? typeData = freezed,Object? grammarTypes = null,}) {
  return _then(_ExerciseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exId: null == exId ? _self.exId : exId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,segmentType: null == segmentType ? _self.segmentType : segmentType // ignore: cast_nullable_to_non_nullable
as String,linkedItemId: freezed == linkedItemId ? _self.linkedItemId : linkedItemId // ignore: cast_nullable_to_non_nullable
as int?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,typeData: freezed == typeData ? _self._typeData : typeData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,grammarTypes: null == grammarTypes ? _self._grammarTypes : grammarTypes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
