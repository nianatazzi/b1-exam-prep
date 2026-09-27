// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_analysis_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpeechAnalysisModel {

 List<LemmaModel> get lemmas;@JsonKey(name: 'targetGrammarErrors') List<SpeechErrorModel> get targetGrammarErrors;@JsonKey(name: 'otherGrammarErrors') List<SpeechErrorModel> get otherGrammarErrors;@JsonKey(name: 'lexicalErrors') List<SpeechErrorModel> get lexicalErrors;@JsonKey(name: 'talkingPointsCovered') List<TalkingPointCoverageModel> get talkingPointsCovered;// 0-15, целостность/связность ответа — холистическая оценка LLM,
// часть рубрики (AppConstants.speechScoreCoherenceMax).
@JsonKey(name: 'coherenceScore') int get coherenceScore;
/// Create a copy of SpeechAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechAnalysisModelCopyWith<SpeechAnalysisModel> get copyWith => _$SpeechAnalysisModelCopyWithImpl<SpeechAnalysisModel>(this as SpeechAnalysisModel, _$identity);

  /// Serializes this SpeechAnalysisModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechAnalysisModel&&const DeepCollectionEquality().equals(other.lemmas, lemmas)&&const DeepCollectionEquality().equals(other.targetGrammarErrors, targetGrammarErrors)&&const DeepCollectionEquality().equals(other.otherGrammarErrors, otherGrammarErrors)&&const DeepCollectionEquality().equals(other.lexicalErrors, lexicalErrors)&&const DeepCollectionEquality().equals(other.talkingPointsCovered, talkingPointsCovered)&&(identical(other.coherenceScore, coherenceScore) || other.coherenceScore == coherenceScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lemmas),const DeepCollectionEquality().hash(targetGrammarErrors),const DeepCollectionEquality().hash(otherGrammarErrors),const DeepCollectionEquality().hash(lexicalErrors),const DeepCollectionEquality().hash(talkingPointsCovered),coherenceScore);

@override
String toString() {
  return 'SpeechAnalysisModel(lemmas: $lemmas, targetGrammarErrors: $targetGrammarErrors, otherGrammarErrors: $otherGrammarErrors, lexicalErrors: $lexicalErrors, talkingPointsCovered: $talkingPointsCovered, coherenceScore: $coherenceScore)';
}


}

/// @nodoc
abstract mixin class $SpeechAnalysisModelCopyWith<$Res>  {
  factory $SpeechAnalysisModelCopyWith(SpeechAnalysisModel value, $Res Function(SpeechAnalysisModel) _then) = _$SpeechAnalysisModelCopyWithImpl;
@useResult
$Res call({
 List<LemmaModel> lemmas,@JsonKey(name: 'targetGrammarErrors') List<SpeechErrorModel> targetGrammarErrors,@JsonKey(name: 'otherGrammarErrors') List<SpeechErrorModel> otherGrammarErrors,@JsonKey(name: 'lexicalErrors') List<SpeechErrorModel> lexicalErrors,@JsonKey(name: 'talkingPointsCovered') List<TalkingPointCoverageModel> talkingPointsCovered,@JsonKey(name: 'coherenceScore') int coherenceScore
});




}
/// @nodoc
class _$SpeechAnalysisModelCopyWithImpl<$Res>
    implements $SpeechAnalysisModelCopyWith<$Res> {
  _$SpeechAnalysisModelCopyWithImpl(this._self, this._then);

  final SpeechAnalysisModel _self;
  final $Res Function(SpeechAnalysisModel) _then;

/// Create a copy of SpeechAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lemmas = null,Object? targetGrammarErrors = null,Object? otherGrammarErrors = null,Object? lexicalErrors = null,Object? talkingPointsCovered = null,Object? coherenceScore = null,}) {
  return _then(_self.copyWith(
lemmas: null == lemmas ? _self.lemmas : lemmas // ignore: cast_nullable_to_non_nullable
as List<LemmaModel>,targetGrammarErrors: null == targetGrammarErrors ? _self.targetGrammarErrors : targetGrammarErrors // ignore: cast_nullable_to_non_nullable
as List<SpeechErrorModel>,otherGrammarErrors: null == otherGrammarErrors ? _self.otherGrammarErrors : otherGrammarErrors // ignore: cast_nullable_to_non_nullable
as List<SpeechErrorModel>,lexicalErrors: null == lexicalErrors ? _self.lexicalErrors : lexicalErrors // ignore: cast_nullable_to_non_nullable
as List<SpeechErrorModel>,talkingPointsCovered: null == talkingPointsCovered ? _self.talkingPointsCovered : talkingPointsCovered // ignore: cast_nullable_to_non_nullable
as List<TalkingPointCoverageModel>,coherenceScore: null == coherenceScore ? _self.coherenceScore : coherenceScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeechAnalysisModel].
extension SpeechAnalysisModelPatterns on SpeechAnalysisModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeechAnalysisModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeechAnalysisModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeechAnalysisModel value)  $default,){
final _that = this;
switch (_that) {
case _SpeechAnalysisModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeechAnalysisModel value)?  $default,){
final _that = this;
switch (_that) {
case _SpeechAnalysisModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LemmaModel> lemmas, @JsonKey(name: 'targetGrammarErrors')  List<SpeechErrorModel> targetGrammarErrors, @JsonKey(name: 'otherGrammarErrors')  List<SpeechErrorModel> otherGrammarErrors, @JsonKey(name: 'lexicalErrors')  List<SpeechErrorModel> lexicalErrors, @JsonKey(name: 'talkingPointsCovered')  List<TalkingPointCoverageModel> talkingPointsCovered, @JsonKey(name: 'coherenceScore')  int coherenceScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeechAnalysisModel() when $default != null:
return $default(_that.lemmas,_that.targetGrammarErrors,_that.otherGrammarErrors,_that.lexicalErrors,_that.talkingPointsCovered,_that.coherenceScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LemmaModel> lemmas, @JsonKey(name: 'targetGrammarErrors')  List<SpeechErrorModel> targetGrammarErrors, @JsonKey(name: 'otherGrammarErrors')  List<SpeechErrorModel> otherGrammarErrors, @JsonKey(name: 'lexicalErrors')  List<SpeechErrorModel> lexicalErrors, @JsonKey(name: 'talkingPointsCovered')  List<TalkingPointCoverageModel> talkingPointsCovered, @JsonKey(name: 'coherenceScore')  int coherenceScore)  $default,) {final _that = this;
switch (_that) {
case _SpeechAnalysisModel():
return $default(_that.lemmas,_that.targetGrammarErrors,_that.otherGrammarErrors,_that.lexicalErrors,_that.talkingPointsCovered,_that.coherenceScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LemmaModel> lemmas, @JsonKey(name: 'targetGrammarErrors')  List<SpeechErrorModel> targetGrammarErrors, @JsonKey(name: 'otherGrammarErrors')  List<SpeechErrorModel> otherGrammarErrors, @JsonKey(name: 'lexicalErrors')  List<SpeechErrorModel> lexicalErrors, @JsonKey(name: 'talkingPointsCovered')  List<TalkingPointCoverageModel> talkingPointsCovered, @JsonKey(name: 'coherenceScore')  int coherenceScore)?  $default,) {final _that = this;
switch (_that) {
case _SpeechAnalysisModel() when $default != null:
return $default(_that.lemmas,_that.targetGrammarErrors,_that.otherGrammarErrors,_that.lexicalErrors,_that.talkingPointsCovered,_that.coherenceScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeechAnalysisModel implements SpeechAnalysisModel {
  const _SpeechAnalysisModel({final  List<LemmaModel> lemmas = const <LemmaModel>[], @JsonKey(name: 'targetGrammarErrors') final  List<SpeechErrorModel> targetGrammarErrors = const <SpeechErrorModel>[], @JsonKey(name: 'otherGrammarErrors') final  List<SpeechErrorModel> otherGrammarErrors = const <SpeechErrorModel>[], @JsonKey(name: 'lexicalErrors') final  List<SpeechErrorModel> lexicalErrors = const <SpeechErrorModel>[], @JsonKey(name: 'talkingPointsCovered') final  List<TalkingPointCoverageModel> talkingPointsCovered = const <TalkingPointCoverageModel>[], @JsonKey(name: 'coherenceScore') this.coherenceScore = 0}): _lemmas = lemmas,_targetGrammarErrors = targetGrammarErrors,_otherGrammarErrors = otherGrammarErrors,_lexicalErrors = lexicalErrors,_talkingPointsCovered = talkingPointsCovered;
  factory _SpeechAnalysisModel.fromJson(Map<String, dynamic> json) => _$SpeechAnalysisModelFromJson(json);

 final  List<LemmaModel> _lemmas;
@override@JsonKey() List<LemmaModel> get lemmas {
  if (_lemmas is EqualUnmodifiableListView) return _lemmas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lemmas);
}

 final  List<SpeechErrorModel> _targetGrammarErrors;
@override@JsonKey(name: 'targetGrammarErrors') List<SpeechErrorModel> get targetGrammarErrors {
  if (_targetGrammarErrors is EqualUnmodifiableListView) return _targetGrammarErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_targetGrammarErrors);
}

 final  List<SpeechErrorModel> _otherGrammarErrors;
@override@JsonKey(name: 'otherGrammarErrors') List<SpeechErrorModel> get otherGrammarErrors {
  if (_otherGrammarErrors is EqualUnmodifiableListView) return _otherGrammarErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_otherGrammarErrors);
}

 final  List<SpeechErrorModel> _lexicalErrors;
@override@JsonKey(name: 'lexicalErrors') List<SpeechErrorModel> get lexicalErrors {
  if (_lexicalErrors is EqualUnmodifiableListView) return _lexicalErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lexicalErrors);
}

 final  List<TalkingPointCoverageModel> _talkingPointsCovered;
@override@JsonKey(name: 'talkingPointsCovered') List<TalkingPointCoverageModel> get talkingPointsCovered {
  if (_talkingPointsCovered is EqualUnmodifiableListView) return _talkingPointsCovered;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_talkingPointsCovered);
}

// 0-15, целостность/связность ответа — холистическая оценка LLM,
// часть рубрики (AppConstants.speechScoreCoherenceMax).
@override@JsonKey(name: 'coherenceScore') final  int coherenceScore;

/// Create a copy of SpeechAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeechAnalysisModelCopyWith<_SpeechAnalysisModel> get copyWith => __$SpeechAnalysisModelCopyWithImpl<_SpeechAnalysisModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeechAnalysisModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeechAnalysisModel&&const DeepCollectionEquality().equals(other._lemmas, _lemmas)&&const DeepCollectionEquality().equals(other._targetGrammarErrors, _targetGrammarErrors)&&const DeepCollectionEquality().equals(other._otherGrammarErrors, _otherGrammarErrors)&&const DeepCollectionEquality().equals(other._lexicalErrors, _lexicalErrors)&&const DeepCollectionEquality().equals(other._talkingPointsCovered, _talkingPointsCovered)&&(identical(other.coherenceScore, coherenceScore) || other.coherenceScore == coherenceScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_lemmas),const DeepCollectionEquality().hash(_targetGrammarErrors),const DeepCollectionEquality().hash(_otherGrammarErrors),const DeepCollectionEquality().hash(_lexicalErrors),const DeepCollectionEquality().hash(_talkingPointsCovered),coherenceScore);

@override
String toString() {
  return 'SpeechAnalysisModel(lemmas: $lemmas, targetGrammarErrors: $targetGrammarErrors, otherGrammarErrors: $otherGrammarErrors, lexicalErrors: $lexicalErrors, talkingPointsCovered: $talkingPointsCovered, coherenceScore: $coherenceScore)';
}


}

/// @nodoc
abstract mixin class _$SpeechAnalysisModelCopyWith<$Res> implements $SpeechAnalysisModelCopyWith<$Res> {
  factory _$SpeechAnalysisModelCopyWith(_SpeechAnalysisModel value, $Res Function(_SpeechAnalysisModel) _then) = __$SpeechAnalysisModelCopyWithImpl;
@override @useResult
$Res call({
 List<LemmaModel> lemmas,@JsonKey(name: 'targetGrammarErrors') List<SpeechErrorModel> targetGrammarErrors,@JsonKey(name: 'otherGrammarErrors') List<SpeechErrorModel> otherGrammarErrors,@JsonKey(name: 'lexicalErrors') List<SpeechErrorModel> lexicalErrors,@JsonKey(name: 'talkingPointsCovered') List<TalkingPointCoverageModel> talkingPointsCovered,@JsonKey(name: 'coherenceScore') int coherenceScore
});




}
/// @nodoc
class __$SpeechAnalysisModelCopyWithImpl<$Res>
    implements _$SpeechAnalysisModelCopyWith<$Res> {
  __$SpeechAnalysisModelCopyWithImpl(this._self, this._then);

  final _SpeechAnalysisModel _self;
  final $Res Function(_SpeechAnalysisModel) _then;

/// Create a copy of SpeechAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lemmas = null,Object? targetGrammarErrors = null,Object? otherGrammarErrors = null,Object? lexicalErrors = null,Object? talkingPointsCovered = null,Object? coherenceScore = null,}) {
  return _then(_SpeechAnalysisModel(
lemmas: null == lemmas ? _self._lemmas : lemmas // ignore: cast_nullable_to_non_nullable
as List<LemmaModel>,targetGrammarErrors: null == targetGrammarErrors ? _self._targetGrammarErrors : targetGrammarErrors // ignore: cast_nullable_to_non_nullable
as List<SpeechErrorModel>,otherGrammarErrors: null == otherGrammarErrors ? _self._otherGrammarErrors : otherGrammarErrors // ignore: cast_nullable_to_non_nullable
as List<SpeechErrorModel>,lexicalErrors: null == lexicalErrors ? _self._lexicalErrors : lexicalErrors // ignore: cast_nullable_to_non_nullable
as List<SpeechErrorModel>,talkingPointsCovered: null == talkingPointsCovered ? _self._talkingPointsCovered : talkingPointsCovered // ignore: cast_nullable_to_non_nullable
as List<TalkingPointCoverageModel>,coherenceScore: null == coherenceScore ? _self.coherenceScore : coherenceScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
