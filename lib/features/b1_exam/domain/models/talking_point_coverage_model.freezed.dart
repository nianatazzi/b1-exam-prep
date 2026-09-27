// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'talking_point_coverage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TalkingPointCoverageModel {

 String get point; bool get covered;
/// Create a copy of TalkingPointCoverageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TalkingPointCoverageModelCopyWith<TalkingPointCoverageModel> get copyWith => _$TalkingPointCoverageModelCopyWithImpl<TalkingPointCoverageModel>(this as TalkingPointCoverageModel, _$identity);

  /// Serializes this TalkingPointCoverageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TalkingPointCoverageModel&&(identical(other.point, point) || other.point == point)&&(identical(other.covered, covered) || other.covered == covered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,point,covered);

@override
String toString() {
  return 'TalkingPointCoverageModel(point: $point, covered: $covered)';
}


}

/// @nodoc
abstract mixin class $TalkingPointCoverageModelCopyWith<$Res>  {
  factory $TalkingPointCoverageModelCopyWith(TalkingPointCoverageModel value, $Res Function(TalkingPointCoverageModel) _then) = _$TalkingPointCoverageModelCopyWithImpl;
@useResult
$Res call({
 String point, bool covered
});




}
/// @nodoc
class _$TalkingPointCoverageModelCopyWithImpl<$Res>
    implements $TalkingPointCoverageModelCopyWith<$Res> {
  _$TalkingPointCoverageModelCopyWithImpl(this._self, this._then);

  final TalkingPointCoverageModel _self;
  final $Res Function(TalkingPointCoverageModel) _then;

/// Create a copy of TalkingPointCoverageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? point = null,Object? covered = null,}) {
  return _then(_self.copyWith(
point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as String,covered: null == covered ? _self.covered : covered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TalkingPointCoverageModel].
extension TalkingPointCoverageModelPatterns on TalkingPointCoverageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TalkingPointCoverageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TalkingPointCoverageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TalkingPointCoverageModel value)  $default,){
final _that = this;
switch (_that) {
case _TalkingPointCoverageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TalkingPointCoverageModel value)?  $default,){
final _that = this;
switch (_that) {
case _TalkingPointCoverageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String point,  bool covered)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TalkingPointCoverageModel() when $default != null:
return $default(_that.point,_that.covered);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String point,  bool covered)  $default,) {final _that = this;
switch (_that) {
case _TalkingPointCoverageModel():
return $default(_that.point,_that.covered);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String point,  bool covered)?  $default,) {final _that = this;
switch (_that) {
case _TalkingPointCoverageModel() when $default != null:
return $default(_that.point,_that.covered);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TalkingPointCoverageModel implements TalkingPointCoverageModel {
  const _TalkingPointCoverageModel({this.point = '', this.covered = false});
  factory _TalkingPointCoverageModel.fromJson(Map<String, dynamic> json) => _$TalkingPointCoverageModelFromJson(json);

@override@JsonKey() final  String point;
@override@JsonKey() final  bool covered;

/// Create a copy of TalkingPointCoverageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TalkingPointCoverageModelCopyWith<_TalkingPointCoverageModel> get copyWith => __$TalkingPointCoverageModelCopyWithImpl<_TalkingPointCoverageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TalkingPointCoverageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TalkingPointCoverageModel&&(identical(other.point, point) || other.point == point)&&(identical(other.covered, covered) || other.covered == covered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,point,covered);

@override
String toString() {
  return 'TalkingPointCoverageModel(point: $point, covered: $covered)';
}


}

/// @nodoc
abstract mixin class _$TalkingPointCoverageModelCopyWith<$Res> implements $TalkingPointCoverageModelCopyWith<$Res> {
  factory _$TalkingPointCoverageModelCopyWith(_TalkingPointCoverageModel value, $Res Function(_TalkingPointCoverageModel) _then) = __$TalkingPointCoverageModelCopyWithImpl;
@override @useResult
$Res call({
 String point, bool covered
});




}
/// @nodoc
class __$TalkingPointCoverageModelCopyWithImpl<$Res>
    implements _$TalkingPointCoverageModelCopyWith<$Res> {
  __$TalkingPointCoverageModelCopyWithImpl(this._self, this._then);

  final _TalkingPointCoverageModel _self;
  final $Res Function(_TalkingPointCoverageModel) _then;

/// Create a copy of TalkingPointCoverageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? point = null,Object? covered = null,}) {
  return _then(_TalkingPointCoverageModel(
point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as String,covered: null == covered ? _self.covered : covered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
