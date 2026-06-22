// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'step_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StepResultModel {

 int get correct; int get total; bool get firstAttempt; DateTime? get completedAt; List<String> get incorrectExerciseIds;
/// Create a copy of StepResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepResultModelCopyWith<StepResultModel> get copyWith => _$StepResultModelCopyWithImpl<StepResultModel>(this as StepResultModel, _$identity);

  /// Serializes this StepResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepResultModel&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.total, total) || other.total == total)&&(identical(other.firstAttempt, firstAttempt) || other.firstAttempt == firstAttempt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other.incorrectExerciseIds, incorrectExerciseIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,total,firstAttempt,completedAt,const DeepCollectionEquality().hash(incorrectExerciseIds));

@override
String toString() {
  return 'StepResultModel(correct: $correct, total: $total, firstAttempt: $firstAttempt, completedAt: $completedAt, incorrectExerciseIds: $incorrectExerciseIds)';
}


}

/// @nodoc
abstract mixin class $StepResultModelCopyWith<$Res>  {
  factory $StepResultModelCopyWith(StepResultModel value, $Res Function(StepResultModel) _then) = _$StepResultModelCopyWithImpl;
@useResult
$Res call({
 int correct, int total, bool firstAttempt, DateTime? completedAt, List<String> incorrectExerciseIds
});




}
/// @nodoc
class _$StepResultModelCopyWithImpl<$Res>
    implements $StepResultModelCopyWith<$Res> {
  _$StepResultModelCopyWithImpl(this._self, this._then);

  final StepResultModel _self;
  final $Res Function(StepResultModel) _then;

/// Create a copy of StepResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correct = null,Object? total = null,Object? firstAttempt = null,Object? completedAt = freezed,Object? incorrectExerciseIds = null,}) {
  return _then(_self.copyWith(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,firstAttempt: null == firstAttempt ? _self.firstAttempt : firstAttempt // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,incorrectExerciseIds: null == incorrectExerciseIds ? _self.incorrectExerciseIds : incorrectExerciseIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [StepResultModel].
extension StepResultModelPatterns on StepResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepResultModel value)  $default,){
final _that = this;
switch (_that) {
case _StepResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _StepResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int correct,  int total,  bool firstAttempt,  DateTime? completedAt,  List<String> incorrectExerciseIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepResultModel() when $default != null:
return $default(_that.correct,_that.total,_that.firstAttempt,_that.completedAt,_that.incorrectExerciseIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int correct,  int total,  bool firstAttempt,  DateTime? completedAt,  List<String> incorrectExerciseIds)  $default,) {final _that = this;
switch (_that) {
case _StepResultModel():
return $default(_that.correct,_that.total,_that.firstAttempt,_that.completedAt,_that.incorrectExerciseIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int correct,  int total,  bool firstAttempt,  DateTime? completedAt,  List<String> incorrectExerciseIds)?  $default,) {final _that = this;
switch (_that) {
case _StepResultModel() when $default != null:
return $default(_that.correct,_that.total,_that.firstAttempt,_that.completedAt,_that.incorrectExerciseIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StepResultModel implements StepResultModel {
  const _StepResultModel({this.correct = 0, this.total = 0, this.firstAttempt = false, this.completedAt, final  List<String> incorrectExerciseIds = const <String>[]}): _incorrectExerciseIds = incorrectExerciseIds;
  factory _StepResultModel.fromJson(Map<String, dynamic> json) => _$StepResultModelFromJson(json);

@override@JsonKey() final  int correct;
@override@JsonKey() final  int total;
@override@JsonKey() final  bool firstAttempt;
@override final  DateTime? completedAt;
 final  List<String> _incorrectExerciseIds;
@override@JsonKey() List<String> get incorrectExerciseIds {
  if (_incorrectExerciseIds is EqualUnmodifiableListView) return _incorrectExerciseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incorrectExerciseIds);
}


/// Create a copy of StepResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepResultModelCopyWith<_StepResultModel> get copyWith => __$StepResultModelCopyWithImpl<_StepResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StepResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepResultModel&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.total, total) || other.total == total)&&(identical(other.firstAttempt, firstAttempt) || other.firstAttempt == firstAttempt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other._incorrectExerciseIds, _incorrectExerciseIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,total,firstAttempt,completedAt,const DeepCollectionEquality().hash(_incorrectExerciseIds));

@override
String toString() {
  return 'StepResultModel(correct: $correct, total: $total, firstAttempt: $firstAttempt, completedAt: $completedAt, incorrectExerciseIds: $incorrectExerciseIds)';
}


}

/// @nodoc
abstract mixin class _$StepResultModelCopyWith<$Res> implements $StepResultModelCopyWith<$Res> {
  factory _$StepResultModelCopyWith(_StepResultModel value, $Res Function(_StepResultModel) _then) = __$StepResultModelCopyWithImpl;
@override @useResult
$Res call({
 int correct, int total, bool firstAttempt, DateTime? completedAt, List<String> incorrectExerciseIds
});




}
/// @nodoc
class __$StepResultModelCopyWithImpl<$Res>
    implements _$StepResultModelCopyWith<$Res> {
  __$StepResultModelCopyWithImpl(this._self, this._then);

  final _StepResultModel _self;
  final $Res Function(_StepResultModel) _then;

/// Create a copy of StepResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correct = null,Object? total = null,Object? firstAttempt = null,Object? completedAt = freezed,Object? incorrectExerciseIds = null,}) {
  return _then(_StepResultModel(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,firstAttempt: null == firstAttempt ? _self.firstAttempt : firstAttempt // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,incorrectExerciseIds: null == incorrectExerciseIds ? _self._incorrectExerciseIds : incorrectExerciseIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
