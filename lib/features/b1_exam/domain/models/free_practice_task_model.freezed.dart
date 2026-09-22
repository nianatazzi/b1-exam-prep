// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'free_practice_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FreePracticeTaskModel {

 Map<String, dynamic> get prompt; List<Map<String, dynamic>> get points;@JsonKey(name: 'duration_seconds') int? get durationSeconds;@JsonKey(name: 'think_seconds') int? get thinkSeconds;
/// Create a copy of FreePracticeTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreePracticeTaskModelCopyWith<FreePracticeTaskModel> get copyWith => _$FreePracticeTaskModelCopyWithImpl<FreePracticeTaskModel>(this as FreePracticeTaskModel, _$identity);

  /// Serializes this FreePracticeTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FreePracticeTaskModel&&const DeepCollectionEquality().equals(other.prompt, prompt)&&const DeepCollectionEquality().equals(other.points, points)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.thinkSeconds, thinkSeconds) || other.thinkSeconds == thinkSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(prompt),const DeepCollectionEquality().hash(points),durationSeconds,thinkSeconds);

@override
String toString() {
  return 'FreePracticeTaskModel(prompt: $prompt, points: $points, durationSeconds: $durationSeconds, thinkSeconds: $thinkSeconds)';
}


}

/// @nodoc
abstract mixin class $FreePracticeTaskModelCopyWith<$Res>  {
  factory $FreePracticeTaskModelCopyWith(FreePracticeTaskModel value, $Res Function(FreePracticeTaskModel) _then) = _$FreePracticeTaskModelCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> prompt, List<Map<String, dynamic>> points,@JsonKey(name: 'duration_seconds') int? durationSeconds,@JsonKey(name: 'think_seconds') int? thinkSeconds
});




}
/// @nodoc
class _$FreePracticeTaskModelCopyWithImpl<$Res>
    implements $FreePracticeTaskModelCopyWith<$Res> {
  _$FreePracticeTaskModelCopyWithImpl(this._self, this._then);

  final FreePracticeTaskModel _self;
  final $Res Function(FreePracticeTaskModel) _then;

/// Create a copy of FreePracticeTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prompt = null,Object? points = null,Object? durationSeconds = freezed,Object? thinkSeconds = freezed,}) {
  return _then(_self.copyWith(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,thinkSeconds: freezed == thinkSeconds ? _self.thinkSeconds : thinkSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FreePracticeTaskModel].
extension FreePracticeTaskModelPatterns on FreePracticeTaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FreePracticeTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FreePracticeTaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FreePracticeTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _FreePracticeTaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FreePracticeTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _FreePracticeTaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> prompt,  List<Map<String, dynamic>> points, @JsonKey(name: 'duration_seconds')  int? durationSeconds, @JsonKey(name: 'think_seconds')  int? thinkSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FreePracticeTaskModel() when $default != null:
return $default(_that.prompt,_that.points,_that.durationSeconds,_that.thinkSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> prompt,  List<Map<String, dynamic>> points, @JsonKey(name: 'duration_seconds')  int? durationSeconds, @JsonKey(name: 'think_seconds')  int? thinkSeconds)  $default,) {final _that = this;
switch (_that) {
case _FreePracticeTaskModel():
return $default(_that.prompt,_that.points,_that.durationSeconds,_that.thinkSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> prompt,  List<Map<String, dynamic>> points, @JsonKey(name: 'duration_seconds')  int? durationSeconds, @JsonKey(name: 'think_seconds')  int? thinkSeconds)?  $default,) {final _that = this;
switch (_that) {
case _FreePracticeTaskModel() when $default != null:
return $default(_that.prompt,_that.points,_that.durationSeconds,_that.thinkSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FreePracticeTaskModel implements FreePracticeTaskModel {
  const _FreePracticeTaskModel({final  Map<String, dynamic> prompt = const <String, dynamic>{}, final  List<Map<String, dynamic>> points = const <Map<String, dynamic>>[], @JsonKey(name: 'duration_seconds') this.durationSeconds, @JsonKey(name: 'think_seconds') this.thinkSeconds}): _prompt = prompt,_points = points;
  factory _FreePracticeTaskModel.fromJson(Map<String, dynamic> json) => _$FreePracticeTaskModelFromJson(json);

 final  Map<String, dynamic> _prompt;
@override@JsonKey() Map<String, dynamic> get prompt {
  if (_prompt is EqualUnmodifiableMapView) return _prompt;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_prompt);
}

 final  List<Map<String, dynamic>> _points;
@override@JsonKey() List<Map<String, dynamic>> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override@JsonKey(name: 'duration_seconds') final  int? durationSeconds;
@override@JsonKey(name: 'think_seconds') final  int? thinkSeconds;

/// Create a copy of FreePracticeTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreePracticeTaskModelCopyWith<_FreePracticeTaskModel> get copyWith => __$FreePracticeTaskModelCopyWithImpl<_FreePracticeTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreePracticeTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreePracticeTaskModel&&const DeepCollectionEquality().equals(other._prompt, _prompt)&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.thinkSeconds, thinkSeconds) || other.thinkSeconds == thinkSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_prompt),const DeepCollectionEquality().hash(_points),durationSeconds,thinkSeconds);

@override
String toString() {
  return 'FreePracticeTaskModel(prompt: $prompt, points: $points, durationSeconds: $durationSeconds, thinkSeconds: $thinkSeconds)';
}


}

/// @nodoc
abstract mixin class _$FreePracticeTaskModelCopyWith<$Res> implements $FreePracticeTaskModelCopyWith<$Res> {
  factory _$FreePracticeTaskModelCopyWith(_FreePracticeTaskModel value, $Res Function(_FreePracticeTaskModel) _then) = __$FreePracticeTaskModelCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> prompt, List<Map<String, dynamic>> points,@JsonKey(name: 'duration_seconds') int? durationSeconds,@JsonKey(name: 'think_seconds') int? thinkSeconds
});




}
/// @nodoc
class __$FreePracticeTaskModelCopyWithImpl<$Res>
    implements _$FreePracticeTaskModelCopyWith<$Res> {
  __$FreePracticeTaskModelCopyWithImpl(this._self, this._then);

  final _FreePracticeTaskModel _self;
  final $Res Function(_FreePracticeTaskModel) _then;

/// Create a copy of FreePracticeTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prompt = null,Object? points = null,Object? durationSeconds = freezed,Object? thinkSeconds = freezed,}) {
  return _then(_FreePracticeTaskModel(
prompt: null == prompt ? _self._prompt : prompt // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,thinkSeconds: freezed == thinkSeconds ? _self.thinkSeconds : thinkSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
