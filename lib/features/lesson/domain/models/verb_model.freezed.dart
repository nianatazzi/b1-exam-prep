// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verb_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerbModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'v_id') int get vId; String get title; String get type; Map<String, dynamic> get conjugation; Map<String, dynamic> get translation; Map<String, dynamic> get transcription;
/// Create a copy of VerbModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerbModelCopyWith<VerbModel> get copyWith => _$VerbModelCopyWithImpl<VerbModel>(this as VerbModel, _$identity);

  /// Serializes this VerbModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerbModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vId, vId) || other.vId == vId)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.conjugation, conjugation)&&const DeepCollectionEquality().equals(other.translation, translation)&&const DeepCollectionEquality().equals(other.transcription, transcription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vId,title,type,const DeepCollectionEquality().hash(conjugation),const DeepCollectionEquality().hash(translation),const DeepCollectionEquality().hash(transcription));

@override
String toString() {
  return 'VerbModel(id: $id, vId: $vId, title: $title, type: $type, conjugation: $conjugation, translation: $translation, transcription: $transcription)';
}


}

/// @nodoc
abstract mixin class $VerbModelCopyWith<$Res>  {
  factory $VerbModelCopyWith(VerbModel value, $Res Function(VerbModel) _then) = _$VerbModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'v_id') int vId, String title, String type, Map<String, dynamic> conjugation, Map<String, dynamic> translation, Map<String, dynamic> transcription
});




}
/// @nodoc
class _$VerbModelCopyWithImpl<$Res>
    implements $VerbModelCopyWith<$Res> {
  _$VerbModelCopyWithImpl(this._self, this._then);

  final VerbModel _self;
  final $Res Function(VerbModel) _then;

/// Create a copy of VerbModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vId = null,Object? title = null,Object? type = null,Object? conjugation = null,Object? translation = null,Object? transcription = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vId: null == vId ? _self.vId : vId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,conjugation: null == conjugation ? _self.conjugation : conjugation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [VerbModel].
extension VerbModelPatterns on VerbModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerbModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerbModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerbModel value)  $default,){
final _that = this;
switch (_that) {
case _VerbModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerbModel value)?  $default,){
final _that = this;
switch (_that) {
case _VerbModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'v_id')  int vId,  String title,  String type,  Map<String, dynamic> conjugation,  Map<String, dynamic> translation,  Map<String, dynamic> transcription)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerbModel() when $default != null:
return $default(_that.id,_that.vId,_that.title,_that.type,_that.conjugation,_that.translation,_that.transcription);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'v_id')  int vId,  String title,  String type,  Map<String, dynamic> conjugation,  Map<String, dynamic> translation,  Map<String, dynamic> transcription)  $default,) {final _that = this;
switch (_that) {
case _VerbModel():
return $default(_that.id,_that.vId,_that.title,_that.type,_that.conjugation,_that.translation,_that.transcription);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'v_id')  int vId,  String title,  String type,  Map<String, dynamic> conjugation,  Map<String, dynamic> translation,  Map<String, dynamic> transcription)?  $default,) {final _that = this;
switch (_that) {
case _VerbModel() when $default != null:
return $default(_that.id,_that.vId,_that.title,_that.type,_that.conjugation,_that.translation,_that.transcription);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerbModel implements VerbModel {
  const _VerbModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'v_id') required this.vId, required this.title, this.type = '', final  Map<String, dynamic> conjugation = const <String, dynamic>{}, final  Map<String, dynamic> translation = const <String, dynamic>{}, final  Map<String, dynamic> transcription = const <String, dynamic>{}}): _conjugation = conjugation,_translation = translation,_transcription = transcription;
  factory _VerbModel.fromJson(Map<String, dynamic> json) => _$VerbModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'v_id') final  int vId;
@override final  String title;
@override@JsonKey() final  String type;
 final  Map<String, dynamic> _conjugation;
@override@JsonKey() Map<String, dynamic> get conjugation {
  if (_conjugation is EqualUnmodifiableMapView) return _conjugation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_conjugation);
}

 final  Map<String, dynamic> _translation;
@override@JsonKey() Map<String, dynamic> get translation {
  if (_translation is EqualUnmodifiableMapView) return _translation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_translation);
}

 final  Map<String, dynamic> _transcription;
@override@JsonKey() Map<String, dynamic> get transcription {
  if (_transcription is EqualUnmodifiableMapView) return _transcription;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_transcription);
}


/// Create a copy of VerbModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerbModelCopyWith<_VerbModel> get copyWith => __$VerbModelCopyWithImpl<_VerbModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerbModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerbModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vId, vId) || other.vId == vId)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._conjugation, _conjugation)&&const DeepCollectionEquality().equals(other._translation, _translation)&&const DeepCollectionEquality().equals(other._transcription, _transcription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vId,title,type,const DeepCollectionEquality().hash(_conjugation),const DeepCollectionEquality().hash(_translation),const DeepCollectionEquality().hash(_transcription));

@override
String toString() {
  return 'VerbModel(id: $id, vId: $vId, title: $title, type: $type, conjugation: $conjugation, translation: $translation, transcription: $transcription)';
}


}

/// @nodoc
abstract mixin class _$VerbModelCopyWith<$Res> implements $VerbModelCopyWith<$Res> {
  factory _$VerbModelCopyWith(_VerbModel value, $Res Function(_VerbModel) _then) = __$VerbModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'v_id') int vId, String title, String type, Map<String, dynamic> conjugation, Map<String, dynamic> translation, Map<String, dynamic> transcription
});




}
/// @nodoc
class __$VerbModelCopyWithImpl<$Res>
    implements _$VerbModelCopyWith<$Res> {
  __$VerbModelCopyWithImpl(this._self, this._then);

  final _VerbModel _self;
  final $Res Function(_VerbModel) _then;

/// Create a copy of VerbModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vId = null,Object? title = null,Object? type = null,Object? conjugation = null,Object? translation = null,Object? transcription = null,}) {
  return _then(_VerbModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vId: null == vId ? _self.vId : vId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,conjugation: null == conjugation ? _self._conjugation : conjugation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,translation: null == translation ? _self._translation : translation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,transcription: null == transcription ? _self._transcription : transcription // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
