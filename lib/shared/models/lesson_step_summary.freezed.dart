// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_step_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonStepSummary {

 LessonStepType get type;// topic для theory, set_title для lexical, '' для verbs (виджет подставит ARB)
 String get title;
/// Create a copy of LessonStepSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonStepSummaryCopyWith<LessonStepSummary> get copyWith => _$LessonStepSummaryCopyWithImpl<LessonStepSummary>(this as LessonStepSummary, _$identity);

  /// Serializes this LessonStepSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonStepSummary&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title);

@override
String toString() {
  return 'LessonStepSummary(type: $type, title: $title)';
}


}

/// @nodoc
abstract mixin class $LessonStepSummaryCopyWith<$Res>  {
  factory $LessonStepSummaryCopyWith(LessonStepSummary value, $Res Function(LessonStepSummary) _then) = _$LessonStepSummaryCopyWithImpl;
@useResult
$Res call({
 LessonStepType type, String title
});




}
/// @nodoc
class _$LessonStepSummaryCopyWithImpl<$Res>
    implements $LessonStepSummaryCopyWith<$Res> {
  _$LessonStepSummaryCopyWithImpl(this._self, this._then);

  final LessonStepSummary _self;
  final $Res Function(LessonStepSummary) _then;

/// Create a copy of LessonStepSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LessonStepType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonStepSummary].
extension LessonStepSummaryPatterns on LessonStepSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonStepSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonStepSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonStepSummary value)  $default,){
final _that = this;
switch (_that) {
case _LessonStepSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonStepSummary value)?  $default,){
final _that = this;
switch (_that) {
case _LessonStepSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LessonStepType type,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonStepSummary() when $default != null:
return $default(_that.type,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LessonStepType type,  String title)  $default,) {final _that = this;
switch (_that) {
case _LessonStepSummary():
return $default(_that.type,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LessonStepType type,  String title)?  $default,) {final _that = this;
switch (_that) {
case _LessonStepSummary() when $default != null:
return $default(_that.type,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonStepSummary implements LessonStepSummary {
  const _LessonStepSummary({required this.type, required this.title});
  factory _LessonStepSummary.fromJson(Map<String, dynamic> json) => _$LessonStepSummaryFromJson(json);

@override final  LessonStepType type;
// topic для theory, set_title для lexical, '' для verbs (виджет подставит ARB)
@override final  String title;

/// Create a copy of LessonStepSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonStepSummaryCopyWith<_LessonStepSummary> get copyWith => __$LessonStepSummaryCopyWithImpl<_LessonStepSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonStepSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonStepSummary&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title);

@override
String toString() {
  return 'LessonStepSummary(type: $type, title: $title)';
}


}

/// @nodoc
abstract mixin class _$LessonStepSummaryCopyWith<$Res> implements $LessonStepSummaryCopyWith<$Res> {
  factory _$LessonStepSummaryCopyWith(_LessonStepSummary value, $Res Function(_LessonStepSummary) _then) = __$LessonStepSummaryCopyWithImpl;
@override @useResult
$Res call({
 LessonStepType type, String title
});




}
/// @nodoc
class __$LessonStepSummaryCopyWithImpl<$Res>
    implements _$LessonStepSummaryCopyWith<$Res> {
  __$LessonStepSummaryCopyWithImpl(this._self, this._then);

  final _LessonStepSummary _self;
  final $Res Function(_LessonStepSummary) _then;

/// Create a copy of LessonStepSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,}) {
  return _then(_LessonStepSummary(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LessonStepType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
