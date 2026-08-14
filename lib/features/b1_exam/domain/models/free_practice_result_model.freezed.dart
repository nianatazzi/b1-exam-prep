// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'free_practice_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FreePracticeResultModel {

 String get transcript;@JsonKey(name: 'durationSeconds') int get durationSeconds; DateTime? get completedAt; FreePracticeAnalysisModel? get analysis;
/// Create a copy of FreePracticeResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreePracticeResultModelCopyWith<FreePracticeResultModel> get copyWith => _$FreePracticeResultModelCopyWithImpl<FreePracticeResultModel>(this as FreePracticeResultModel, _$identity);

  /// Serializes this FreePracticeResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FreePracticeResultModel&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.analysis, analysis) || other.analysis == analysis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transcript,durationSeconds,completedAt,analysis);

@override
String toString() {
  return 'FreePracticeResultModel(transcript: $transcript, durationSeconds: $durationSeconds, completedAt: $completedAt, analysis: $analysis)';
}


}

/// @nodoc
abstract mixin class $FreePracticeResultModelCopyWith<$Res>  {
  factory $FreePracticeResultModelCopyWith(FreePracticeResultModel value, $Res Function(FreePracticeResultModel) _then) = _$FreePracticeResultModelCopyWithImpl;
@useResult
$Res call({
 String transcript,@JsonKey(name: 'durationSeconds') int durationSeconds, DateTime? completedAt, FreePracticeAnalysisModel? analysis
});


$FreePracticeAnalysisModelCopyWith<$Res>? get analysis;

}
/// @nodoc
class _$FreePracticeResultModelCopyWithImpl<$Res>
    implements $FreePracticeResultModelCopyWith<$Res> {
  _$FreePracticeResultModelCopyWithImpl(this._self, this._then);

  final FreePracticeResultModel _self;
  final $Res Function(FreePracticeResultModel) _then;

/// Create a copy of FreePracticeResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transcript = null,Object? durationSeconds = null,Object? completedAt = freezed,Object? analysis = freezed,}) {
  return _then(_self.copyWith(
transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,analysis: freezed == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as FreePracticeAnalysisModel?,
  ));
}
/// Create a copy of FreePracticeResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreePracticeAnalysisModelCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
    return null;
  }

  return $FreePracticeAnalysisModelCopyWith<$Res>(_self.analysis!, (value) {
    return _then(_self.copyWith(analysis: value));
  });
}
}


/// Adds pattern-matching-related methods to [FreePracticeResultModel].
extension FreePracticeResultModelPatterns on FreePracticeResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FreePracticeResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FreePracticeResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FreePracticeResultModel value)  $default,){
final _that = this;
switch (_that) {
case _FreePracticeResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FreePracticeResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _FreePracticeResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transcript, @JsonKey(name: 'durationSeconds')  int durationSeconds,  DateTime? completedAt,  FreePracticeAnalysisModel? analysis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FreePracticeResultModel() when $default != null:
return $default(_that.transcript,_that.durationSeconds,_that.completedAt,_that.analysis);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transcript, @JsonKey(name: 'durationSeconds')  int durationSeconds,  DateTime? completedAt,  FreePracticeAnalysisModel? analysis)  $default,) {final _that = this;
switch (_that) {
case _FreePracticeResultModel():
return $default(_that.transcript,_that.durationSeconds,_that.completedAt,_that.analysis);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transcript, @JsonKey(name: 'durationSeconds')  int durationSeconds,  DateTime? completedAt,  FreePracticeAnalysisModel? analysis)?  $default,) {final _that = this;
switch (_that) {
case _FreePracticeResultModel() when $default != null:
return $default(_that.transcript,_that.durationSeconds,_that.completedAt,_that.analysis);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FreePracticeResultModel implements FreePracticeResultModel {
  const _FreePracticeResultModel({this.transcript = '', @JsonKey(name: 'durationSeconds') this.durationSeconds = 0, this.completedAt, this.analysis});
  factory _FreePracticeResultModel.fromJson(Map<String, dynamic> json) => _$FreePracticeResultModelFromJson(json);

@override@JsonKey() final  String transcript;
@override@JsonKey(name: 'durationSeconds') final  int durationSeconds;
@override final  DateTime? completedAt;
@override final  FreePracticeAnalysisModel? analysis;

/// Create a copy of FreePracticeResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreePracticeResultModelCopyWith<_FreePracticeResultModel> get copyWith => __$FreePracticeResultModelCopyWithImpl<_FreePracticeResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreePracticeResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreePracticeResultModel&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.analysis, analysis) || other.analysis == analysis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transcript,durationSeconds,completedAt,analysis);

@override
String toString() {
  return 'FreePracticeResultModel(transcript: $transcript, durationSeconds: $durationSeconds, completedAt: $completedAt, analysis: $analysis)';
}


}

/// @nodoc
abstract mixin class _$FreePracticeResultModelCopyWith<$Res> implements $FreePracticeResultModelCopyWith<$Res> {
  factory _$FreePracticeResultModelCopyWith(_FreePracticeResultModel value, $Res Function(_FreePracticeResultModel) _then) = __$FreePracticeResultModelCopyWithImpl;
@override @useResult
$Res call({
 String transcript,@JsonKey(name: 'durationSeconds') int durationSeconds, DateTime? completedAt, FreePracticeAnalysisModel? analysis
});


@override $FreePracticeAnalysisModelCopyWith<$Res>? get analysis;

}
/// @nodoc
class __$FreePracticeResultModelCopyWithImpl<$Res>
    implements _$FreePracticeResultModelCopyWith<$Res> {
  __$FreePracticeResultModelCopyWithImpl(this._self, this._then);

  final _FreePracticeResultModel _self;
  final $Res Function(_FreePracticeResultModel) _then;

/// Create a copy of FreePracticeResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transcript = null,Object? durationSeconds = null,Object? completedAt = freezed,Object? analysis = freezed,}) {
  return _then(_FreePracticeResultModel(
transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,analysis: freezed == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as FreePracticeAnalysisModel?,
  ));
}

/// Create a copy of FreePracticeResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreePracticeAnalysisModelCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
    return null;
  }

  return $FreePracticeAnalysisModelCopyWith<$Res>(_self.analysis!, (value) {
    return _then(_self.copyWith(analysis: value));
  });
}
}

// dart format on
