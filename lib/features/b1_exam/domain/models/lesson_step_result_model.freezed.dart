// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_step_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonStepResultModel {

 String? get transcript; List<DialogueMessageModel> get turns;@JsonKey(name: 'durationSeconds') int get durationSeconds; DateTime? get completedAt; int? get score; SpeechAnalysisModel? get analysis;
/// Create a copy of LessonStepResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonStepResultModelCopyWith<LessonStepResultModel> get copyWith => _$LessonStepResultModelCopyWithImpl<LessonStepResultModel>(this as LessonStepResultModel, _$identity);

  /// Serializes this LessonStepResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonStepResultModel&&(identical(other.transcript, transcript) || other.transcript == transcript)&&const DeepCollectionEquality().equals(other.turns, turns)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.score, score) || other.score == score)&&(identical(other.analysis, analysis) || other.analysis == analysis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transcript,const DeepCollectionEquality().hash(turns),durationSeconds,completedAt,score,analysis);

@override
String toString() {
  return 'LessonStepResultModel(transcript: $transcript, turns: $turns, durationSeconds: $durationSeconds, completedAt: $completedAt, score: $score, analysis: $analysis)';
}


}

/// @nodoc
abstract mixin class $LessonStepResultModelCopyWith<$Res>  {
  factory $LessonStepResultModelCopyWith(LessonStepResultModel value, $Res Function(LessonStepResultModel) _then) = _$LessonStepResultModelCopyWithImpl;
@useResult
$Res call({
 String? transcript, List<DialogueMessageModel> turns,@JsonKey(name: 'durationSeconds') int durationSeconds, DateTime? completedAt, int? score, SpeechAnalysisModel? analysis
});


$SpeechAnalysisModelCopyWith<$Res>? get analysis;

}
/// @nodoc
class _$LessonStepResultModelCopyWithImpl<$Res>
    implements $LessonStepResultModelCopyWith<$Res> {
  _$LessonStepResultModelCopyWithImpl(this._self, this._then);

  final LessonStepResultModel _self;
  final $Res Function(LessonStepResultModel) _then;

/// Create a copy of LessonStepResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transcript = freezed,Object? turns = null,Object? durationSeconds = null,Object? completedAt = freezed,Object? score = freezed,Object? analysis = freezed,}) {
  return _then(_self.copyWith(
transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,turns: null == turns ? _self.turns : turns // ignore: cast_nullable_to_non_nullable
as List<DialogueMessageModel>,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,analysis: freezed == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as SpeechAnalysisModel?,
  ));
}
/// Create a copy of LessonStepResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeechAnalysisModelCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
    return null;
  }

  return $SpeechAnalysisModelCopyWith<$Res>(_self.analysis!, (value) {
    return _then(_self.copyWith(analysis: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonStepResultModel].
extension LessonStepResultModelPatterns on LessonStepResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonStepResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonStepResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonStepResultModel value)  $default,){
final _that = this;
switch (_that) {
case _LessonStepResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonStepResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _LessonStepResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? transcript,  List<DialogueMessageModel> turns, @JsonKey(name: 'durationSeconds')  int durationSeconds,  DateTime? completedAt,  int? score,  SpeechAnalysisModel? analysis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonStepResultModel() when $default != null:
return $default(_that.transcript,_that.turns,_that.durationSeconds,_that.completedAt,_that.score,_that.analysis);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? transcript,  List<DialogueMessageModel> turns, @JsonKey(name: 'durationSeconds')  int durationSeconds,  DateTime? completedAt,  int? score,  SpeechAnalysisModel? analysis)  $default,) {final _that = this;
switch (_that) {
case _LessonStepResultModel():
return $default(_that.transcript,_that.turns,_that.durationSeconds,_that.completedAt,_that.score,_that.analysis);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? transcript,  List<DialogueMessageModel> turns, @JsonKey(name: 'durationSeconds')  int durationSeconds,  DateTime? completedAt,  int? score,  SpeechAnalysisModel? analysis)?  $default,) {final _that = this;
switch (_that) {
case _LessonStepResultModel() when $default != null:
return $default(_that.transcript,_that.turns,_that.durationSeconds,_that.completedAt,_that.score,_that.analysis);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonStepResultModel implements LessonStepResultModel {
  const _LessonStepResultModel({this.transcript, final  List<DialogueMessageModel> turns = const <DialogueMessageModel>[], @JsonKey(name: 'durationSeconds') this.durationSeconds = 0, this.completedAt, this.score, this.analysis}): _turns = turns;
  factory _LessonStepResultModel.fromJson(Map<String, dynamic> json) => _$LessonStepResultModelFromJson(json);

@override final  String? transcript;
 final  List<DialogueMessageModel> _turns;
@override@JsonKey() List<DialogueMessageModel> get turns {
  if (_turns is EqualUnmodifiableListView) return _turns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_turns);
}

@override@JsonKey(name: 'durationSeconds') final  int durationSeconds;
@override final  DateTime? completedAt;
@override final  int? score;
@override final  SpeechAnalysisModel? analysis;

/// Create a copy of LessonStepResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonStepResultModelCopyWith<_LessonStepResultModel> get copyWith => __$LessonStepResultModelCopyWithImpl<_LessonStepResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonStepResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonStepResultModel&&(identical(other.transcript, transcript) || other.transcript == transcript)&&const DeepCollectionEquality().equals(other._turns, _turns)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.score, score) || other.score == score)&&(identical(other.analysis, analysis) || other.analysis == analysis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transcript,const DeepCollectionEquality().hash(_turns),durationSeconds,completedAt,score,analysis);

@override
String toString() {
  return 'LessonStepResultModel(transcript: $transcript, turns: $turns, durationSeconds: $durationSeconds, completedAt: $completedAt, score: $score, analysis: $analysis)';
}


}

/// @nodoc
abstract mixin class _$LessonStepResultModelCopyWith<$Res> implements $LessonStepResultModelCopyWith<$Res> {
  factory _$LessonStepResultModelCopyWith(_LessonStepResultModel value, $Res Function(_LessonStepResultModel) _then) = __$LessonStepResultModelCopyWithImpl;
@override @useResult
$Res call({
 String? transcript, List<DialogueMessageModel> turns,@JsonKey(name: 'durationSeconds') int durationSeconds, DateTime? completedAt, int? score, SpeechAnalysisModel? analysis
});


@override $SpeechAnalysisModelCopyWith<$Res>? get analysis;

}
/// @nodoc
class __$LessonStepResultModelCopyWithImpl<$Res>
    implements _$LessonStepResultModelCopyWith<$Res> {
  __$LessonStepResultModelCopyWithImpl(this._self, this._then);

  final _LessonStepResultModel _self;
  final $Res Function(_LessonStepResultModel) _then;

/// Create a copy of LessonStepResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transcript = freezed,Object? turns = null,Object? durationSeconds = null,Object? completedAt = freezed,Object? score = freezed,Object? analysis = freezed,}) {
  return _then(_LessonStepResultModel(
transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,turns: null == turns ? _self._turns : turns // ignore: cast_nullable_to_non_nullable
as List<DialogueMessageModel>,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,analysis: freezed == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as SpeechAnalysisModel?,
  ));
}

/// Create a copy of LessonStepResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeechAnalysisModelCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
    return null;
  }

  return $SpeechAnalysisModelCopyWith<$Res>(_self.analysis!, (value) {
    return _then(_self.copyWith(analysis: value));
  });
}
}

// dart format on
