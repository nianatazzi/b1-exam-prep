// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StreakModel {

 int get currentStreak; int get bestStreak; DateTime? get lastActiveDate;
/// Create a copy of StreakModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakModelCopyWith<StreakModel> get copyWith => _$StreakModelCopyWithImpl<StreakModel>(this as StreakModel, _$identity);

  /// Serializes this StreakModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakModel&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.lastActiveDate, lastActiveDate) || other.lastActiveDate == lastActiveDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreak,bestStreak,lastActiveDate);

@override
String toString() {
  return 'StreakModel(currentStreak: $currentStreak, bestStreak: $bestStreak, lastActiveDate: $lastActiveDate)';
}


}

/// @nodoc
abstract mixin class $StreakModelCopyWith<$Res>  {
  factory $StreakModelCopyWith(StreakModel value, $Res Function(StreakModel) _then) = _$StreakModelCopyWithImpl;
@useResult
$Res call({
 int currentStreak, int bestStreak, DateTime? lastActiveDate
});




}
/// @nodoc
class _$StreakModelCopyWithImpl<$Res>
    implements $StreakModelCopyWith<$Res> {
  _$StreakModelCopyWithImpl(this._self, this._then);

  final StreakModel _self;
  final $Res Function(StreakModel) _then;

/// Create a copy of StreakModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreak = null,Object? bestStreak = null,Object? lastActiveDate = freezed,}) {
  return _then(_self.copyWith(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,lastActiveDate: freezed == lastActiveDate ? _self.lastActiveDate : lastActiveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakModel].
extension StreakModelPatterns on StreakModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakModel value)  $default,){
final _that = this;
switch (_that) {
case _StreakModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakModel value)?  $default,){
final _that = this;
switch (_that) {
case _StreakModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStreak,  int bestStreak,  DateTime? lastActiveDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakModel() when $default != null:
return $default(_that.currentStreak,_that.bestStreak,_that.lastActiveDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStreak,  int bestStreak,  DateTime? lastActiveDate)  $default,) {final _that = this;
switch (_that) {
case _StreakModel():
return $default(_that.currentStreak,_that.bestStreak,_that.lastActiveDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStreak,  int bestStreak,  DateTime? lastActiveDate)?  $default,) {final _that = this;
switch (_that) {
case _StreakModel() when $default != null:
return $default(_that.currentStreak,_that.bestStreak,_that.lastActiveDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreakModel extends StreakModel {
  const _StreakModel({this.currentStreak = 0, this.bestStreak = 0, this.lastActiveDate}): super._();
  factory _StreakModel.fromJson(Map<String, dynamic> json) => _$StreakModelFromJson(json);

@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int bestStreak;
@override final  DateTime? lastActiveDate;

/// Create a copy of StreakModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakModelCopyWith<_StreakModel> get copyWith => __$StreakModelCopyWithImpl<_StreakModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakModel&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.lastActiveDate, lastActiveDate) || other.lastActiveDate == lastActiveDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreak,bestStreak,lastActiveDate);

@override
String toString() {
  return 'StreakModel(currentStreak: $currentStreak, bestStreak: $bestStreak, lastActiveDate: $lastActiveDate)';
}


}

/// @nodoc
abstract mixin class _$StreakModelCopyWith<$Res> implements $StreakModelCopyWith<$Res> {
  factory _$StreakModelCopyWith(_StreakModel value, $Res Function(_StreakModel) _then) = __$StreakModelCopyWithImpl;
@override @useResult
$Res call({
 int currentStreak, int bestStreak, DateTime? lastActiveDate
});




}
/// @nodoc
class __$StreakModelCopyWithImpl<$Res>
    implements _$StreakModelCopyWith<$Res> {
  __$StreakModelCopyWithImpl(this._self, this._then);

  final _StreakModel _self;
  final $Res Function(_StreakModel) _then;

/// Create a copy of StreakModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreak = null,Object? bestStreak = null,Object? lastActiveDate = freezed,}) {
  return _then(_StreakModel(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,lastActiveDate: freezed == lastActiveDate ? _self.lastActiveDate : lastActiveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
