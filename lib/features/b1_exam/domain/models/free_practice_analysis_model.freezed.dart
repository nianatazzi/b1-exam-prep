// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'free_practice_analysis_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FreePracticeAnalysisModel {

@JsonKey(name: 'misusedWords') List<MisusedWordModel> get misusedWords;
/// Create a copy of FreePracticeAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreePracticeAnalysisModelCopyWith<FreePracticeAnalysisModel> get copyWith => _$FreePracticeAnalysisModelCopyWithImpl<FreePracticeAnalysisModel>(this as FreePracticeAnalysisModel, _$identity);

  /// Serializes this FreePracticeAnalysisModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FreePracticeAnalysisModel&&const DeepCollectionEquality().equals(other.misusedWords, misusedWords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(misusedWords));

@override
String toString() {
  return 'FreePracticeAnalysisModel(misusedWords: $misusedWords)';
}


}

/// @nodoc
abstract mixin class $FreePracticeAnalysisModelCopyWith<$Res>  {
  factory $FreePracticeAnalysisModelCopyWith(FreePracticeAnalysisModel value, $Res Function(FreePracticeAnalysisModel) _then) = _$FreePracticeAnalysisModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'misusedWords') List<MisusedWordModel> misusedWords
});




}
/// @nodoc
class _$FreePracticeAnalysisModelCopyWithImpl<$Res>
    implements $FreePracticeAnalysisModelCopyWith<$Res> {
  _$FreePracticeAnalysisModelCopyWithImpl(this._self, this._then);

  final FreePracticeAnalysisModel _self;
  final $Res Function(FreePracticeAnalysisModel) _then;

/// Create a copy of FreePracticeAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? misusedWords = null,}) {
  return _then(_self.copyWith(
misusedWords: null == misusedWords ? _self.misusedWords : misusedWords // ignore: cast_nullable_to_non_nullable
as List<MisusedWordModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [FreePracticeAnalysisModel].
extension FreePracticeAnalysisModelPatterns on FreePracticeAnalysisModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FreePracticeAnalysisModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FreePracticeAnalysisModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FreePracticeAnalysisModel value)  $default,){
final _that = this;
switch (_that) {
case _FreePracticeAnalysisModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FreePracticeAnalysisModel value)?  $default,){
final _that = this;
switch (_that) {
case _FreePracticeAnalysisModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'misusedWords')  List<MisusedWordModel> misusedWords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FreePracticeAnalysisModel() when $default != null:
return $default(_that.misusedWords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'misusedWords')  List<MisusedWordModel> misusedWords)  $default,) {final _that = this;
switch (_that) {
case _FreePracticeAnalysisModel():
return $default(_that.misusedWords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'misusedWords')  List<MisusedWordModel> misusedWords)?  $default,) {final _that = this;
switch (_that) {
case _FreePracticeAnalysisModel() when $default != null:
return $default(_that.misusedWords);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FreePracticeAnalysisModel implements FreePracticeAnalysisModel {
  const _FreePracticeAnalysisModel({@JsonKey(name: 'misusedWords') final  List<MisusedWordModel> misusedWords = const <MisusedWordModel>[]}): _misusedWords = misusedWords;
  factory _FreePracticeAnalysisModel.fromJson(Map<String, dynamic> json) => _$FreePracticeAnalysisModelFromJson(json);

 final  List<MisusedWordModel> _misusedWords;
@override@JsonKey(name: 'misusedWords') List<MisusedWordModel> get misusedWords {
  if (_misusedWords is EqualUnmodifiableListView) return _misusedWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_misusedWords);
}


/// Create a copy of FreePracticeAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreePracticeAnalysisModelCopyWith<_FreePracticeAnalysisModel> get copyWith => __$FreePracticeAnalysisModelCopyWithImpl<_FreePracticeAnalysisModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreePracticeAnalysisModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreePracticeAnalysisModel&&const DeepCollectionEquality().equals(other._misusedWords, _misusedWords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_misusedWords));

@override
String toString() {
  return 'FreePracticeAnalysisModel(misusedWords: $misusedWords)';
}


}

/// @nodoc
abstract mixin class _$FreePracticeAnalysisModelCopyWith<$Res> implements $FreePracticeAnalysisModelCopyWith<$Res> {
  factory _$FreePracticeAnalysisModelCopyWith(_FreePracticeAnalysisModel value, $Res Function(_FreePracticeAnalysisModel) _then) = __$FreePracticeAnalysisModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'misusedWords') List<MisusedWordModel> misusedWords
});




}
/// @nodoc
class __$FreePracticeAnalysisModelCopyWithImpl<$Res>
    implements _$FreePracticeAnalysisModelCopyWith<$Res> {
  __$FreePracticeAnalysisModelCopyWithImpl(this._self, this._then);

  final _FreePracticeAnalysisModel _self;
  final $Res Function(_FreePracticeAnalysisModel) _then;

/// Create a copy of FreePracticeAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? misusedWords = null,}) {
  return _then(_FreePracticeAnalysisModel(
misusedWords: null == misusedWords ? _self._misusedWords : misusedWords // ignore: cast_nullable_to_non_nullable
as List<MisusedWordModel>,
  ));
}


}

// dart format on
