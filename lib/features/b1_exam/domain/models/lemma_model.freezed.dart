// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lemma_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LemmaModel {

@JsonKey(name: 'surfaceForm') String get surfaceForm; String get lemma;@JsonKey(name: 'partOfSpeech') String get partOfSpeech;
/// Create a copy of LemmaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LemmaModelCopyWith<LemmaModel> get copyWith => _$LemmaModelCopyWithImpl<LemmaModel>(this as LemmaModel, _$identity);

  /// Serializes this LemmaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LemmaModel&&(identical(other.surfaceForm, surfaceForm) || other.surfaceForm == surfaceForm)&&(identical(other.lemma, lemma) || other.lemma == lemma)&&(identical(other.partOfSpeech, partOfSpeech) || other.partOfSpeech == partOfSpeech));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surfaceForm,lemma,partOfSpeech);

@override
String toString() {
  return 'LemmaModel(surfaceForm: $surfaceForm, lemma: $lemma, partOfSpeech: $partOfSpeech)';
}


}

/// @nodoc
abstract mixin class $LemmaModelCopyWith<$Res>  {
  factory $LemmaModelCopyWith(LemmaModel value, $Res Function(LemmaModel) _then) = _$LemmaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'surfaceForm') String surfaceForm, String lemma,@JsonKey(name: 'partOfSpeech') String partOfSpeech
});




}
/// @nodoc
class _$LemmaModelCopyWithImpl<$Res>
    implements $LemmaModelCopyWith<$Res> {
  _$LemmaModelCopyWithImpl(this._self, this._then);

  final LemmaModel _self;
  final $Res Function(LemmaModel) _then;

/// Create a copy of LemmaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surfaceForm = null,Object? lemma = null,Object? partOfSpeech = null,}) {
  return _then(_self.copyWith(
surfaceForm: null == surfaceForm ? _self.surfaceForm : surfaceForm // ignore: cast_nullable_to_non_nullable
as String,lemma: null == lemma ? _self.lemma : lemma // ignore: cast_nullable_to_non_nullable
as String,partOfSpeech: null == partOfSpeech ? _self.partOfSpeech : partOfSpeech // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LemmaModel].
extension LemmaModelPatterns on LemmaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LemmaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LemmaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LemmaModel value)  $default,){
final _that = this;
switch (_that) {
case _LemmaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LemmaModel value)?  $default,){
final _that = this;
switch (_that) {
case _LemmaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'surfaceForm')  String surfaceForm,  String lemma, @JsonKey(name: 'partOfSpeech')  String partOfSpeech)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LemmaModel() when $default != null:
return $default(_that.surfaceForm,_that.lemma,_that.partOfSpeech);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'surfaceForm')  String surfaceForm,  String lemma, @JsonKey(name: 'partOfSpeech')  String partOfSpeech)  $default,) {final _that = this;
switch (_that) {
case _LemmaModel():
return $default(_that.surfaceForm,_that.lemma,_that.partOfSpeech);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'surfaceForm')  String surfaceForm,  String lemma, @JsonKey(name: 'partOfSpeech')  String partOfSpeech)?  $default,) {final _that = this;
switch (_that) {
case _LemmaModel() when $default != null:
return $default(_that.surfaceForm,_that.lemma,_that.partOfSpeech);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LemmaModel implements LemmaModel {
  const _LemmaModel({@JsonKey(name: 'surfaceForm') this.surfaceForm = '', this.lemma = '', @JsonKey(name: 'partOfSpeech') this.partOfSpeech = ''});
  factory _LemmaModel.fromJson(Map<String, dynamic> json) => _$LemmaModelFromJson(json);

@override@JsonKey(name: 'surfaceForm') final  String surfaceForm;
@override@JsonKey() final  String lemma;
@override@JsonKey(name: 'partOfSpeech') final  String partOfSpeech;

/// Create a copy of LemmaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LemmaModelCopyWith<_LemmaModel> get copyWith => __$LemmaModelCopyWithImpl<_LemmaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LemmaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LemmaModel&&(identical(other.surfaceForm, surfaceForm) || other.surfaceForm == surfaceForm)&&(identical(other.lemma, lemma) || other.lemma == lemma)&&(identical(other.partOfSpeech, partOfSpeech) || other.partOfSpeech == partOfSpeech));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surfaceForm,lemma,partOfSpeech);

@override
String toString() {
  return 'LemmaModel(surfaceForm: $surfaceForm, lemma: $lemma, partOfSpeech: $partOfSpeech)';
}


}

/// @nodoc
abstract mixin class _$LemmaModelCopyWith<$Res> implements $LemmaModelCopyWith<$Res> {
  factory _$LemmaModelCopyWith(_LemmaModel value, $Res Function(_LemmaModel) _then) = __$LemmaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'surfaceForm') String surfaceForm, String lemma,@JsonKey(name: 'partOfSpeech') String partOfSpeech
});




}
/// @nodoc
class __$LemmaModelCopyWithImpl<$Res>
    implements _$LemmaModelCopyWith<$Res> {
  __$LemmaModelCopyWithImpl(this._self, this._then);

  final _LemmaModel _self;
  final $Res Function(_LemmaModel) _then;

/// Create a copy of LemmaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surfaceForm = null,Object? lemma = null,Object? partOfSpeech = null,}) {
  return _then(_LemmaModel(
surfaceForm: null == surfaceForm ? _self.surfaceForm : surfaceForm // ignore: cast_nullable_to_non_nullable
as String,lemma: null == lemma ? _self.lemma : lemma // ignore: cast_nullable_to_non_nullable
as String,partOfSpeech: null == partOfSpeech ? _self.partOfSpeech : partOfSpeech // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
