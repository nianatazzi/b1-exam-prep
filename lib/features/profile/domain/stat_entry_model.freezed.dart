// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stat_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatEntryModel {

 int get correct; int get total;
/// Create a copy of StatEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatEntryModelCopyWith<StatEntryModel> get copyWith => _$StatEntryModelCopyWithImpl<StatEntryModel>(this as StatEntryModel, _$identity);

  /// Serializes this StatEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatEntryModel&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,total);

@override
String toString() {
  return 'StatEntryModel(correct: $correct, total: $total)';
}


}

/// @nodoc
abstract mixin class $StatEntryModelCopyWith<$Res>  {
  factory $StatEntryModelCopyWith(StatEntryModel value, $Res Function(StatEntryModel) _then) = _$StatEntryModelCopyWithImpl;
@useResult
$Res call({
 int correct, int total
});




}
/// @nodoc
class _$StatEntryModelCopyWithImpl<$Res>
    implements $StatEntryModelCopyWith<$Res> {
  _$StatEntryModelCopyWithImpl(this._self, this._then);

  final StatEntryModel _self;
  final $Res Function(StatEntryModel) _then;

/// Create a copy of StatEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correct = null,Object? total = null,}) {
  return _then(_self.copyWith(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StatEntryModel].
extension StatEntryModelPatterns on StatEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _StatEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _StatEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int correct,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatEntryModel() when $default != null:
return $default(_that.correct,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int correct,  int total)  $default,) {final _that = this;
switch (_that) {
case _StatEntryModel():
return $default(_that.correct,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int correct,  int total)?  $default,) {final _that = this;
switch (_that) {
case _StatEntryModel() when $default != null:
return $default(_that.correct,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatEntryModel extends StatEntryModel {
  const _StatEntryModel({this.correct = 0, this.total = 0}): super._();
  factory _StatEntryModel.fromJson(Map<String, dynamic> json) => _$StatEntryModelFromJson(json);

@override@JsonKey() final  int correct;
@override@JsonKey() final  int total;

/// Create a copy of StatEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatEntryModelCopyWith<_StatEntryModel> get copyWith => __$StatEntryModelCopyWithImpl<_StatEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatEntryModel&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,total);

@override
String toString() {
  return 'StatEntryModel(correct: $correct, total: $total)';
}


}

/// @nodoc
abstract mixin class _$StatEntryModelCopyWith<$Res> implements $StatEntryModelCopyWith<$Res> {
  factory _$StatEntryModelCopyWith(_StatEntryModel value, $Res Function(_StatEntryModel) _then) = __$StatEntryModelCopyWithImpl;
@override @useResult
$Res call({
 int correct, int total
});




}
/// @nodoc
class __$StatEntryModelCopyWithImpl<$Res>
    implements _$StatEntryModelCopyWith<$Res> {
  __$StatEntryModelCopyWithImpl(this._self, this._then);

  final _StatEntryModel _self;
  final $Res Function(_StatEntryModel) _then;

/// Create a copy of StatEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correct = null,Object? total = null,}) {
  return _then(_StatEntryModel(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
