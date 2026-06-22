// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseStatsModel {

 StatEntryModel get grammar; StatEntryModel get vocabulary; StatEntryModel get listening; StatEntryModel get speaking;
/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseStatsModelCopyWith<ExerciseStatsModel> get copyWith => _$ExerciseStatsModelCopyWithImpl<ExerciseStatsModel>(this as ExerciseStatsModel, _$identity);

  /// Serializes this ExerciseStatsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseStatsModel&&(identical(other.grammar, grammar) || other.grammar == grammar)&&(identical(other.vocabulary, vocabulary) || other.vocabulary == vocabulary)&&(identical(other.listening, listening) || other.listening == listening)&&(identical(other.speaking, speaking) || other.speaking == speaking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grammar,vocabulary,listening,speaking);

@override
String toString() {
  return 'ExerciseStatsModel(grammar: $grammar, vocabulary: $vocabulary, listening: $listening, speaking: $speaking)';
}


}

/// @nodoc
abstract mixin class $ExerciseStatsModelCopyWith<$Res>  {
  factory $ExerciseStatsModelCopyWith(ExerciseStatsModel value, $Res Function(ExerciseStatsModel) _then) = _$ExerciseStatsModelCopyWithImpl;
@useResult
$Res call({
 StatEntryModel grammar, StatEntryModel vocabulary, StatEntryModel listening, StatEntryModel speaking
});


$StatEntryModelCopyWith<$Res> get grammar;$StatEntryModelCopyWith<$Res> get vocabulary;$StatEntryModelCopyWith<$Res> get listening;$StatEntryModelCopyWith<$Res> get speaking;

}
/// @nodoc
class _$ExerciseStatsModelCopyWithImpl<$Res>
    implements $ExerciseStatsModelCopyWith<$Res> {
  _$ExerciseStatsModelCopyWithImpl(this._self, this._then);

  final ExerciseStatsModel _self;
  final $Res Function(ExerciseStatsModel) _then;

/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? grammar = null,Object? vocabulary = null,Object? listening = null,Object? speaking = null,}) {
  return _then(_self.copyWith(
grammar: null == grammar ? _self.grammar : grammar // ignore: cast_nullable_to_non_nullable
as StatEntryModel,vocabulary: null == vocabulary ? _self.vocabulary : vocabulary // ignore: cast_nullable_to_non_nullable
as StatEntryModel,listening: null == listening ? _self.listening : listening // ignore: cast_nullable_to_non_nullable
as StatEntryModel,speaking: null == speaking ? _self.speaking : speaking // ignore: cast_nullable_to_non_nullable
as StatEntryModel,
  ));
}
/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatEntryModelCopyWith<$Res> get grammar {
  
  return $StatEntryModelCopyWith<$Res>(_self.grammar, (value) {
    return _then(_self.copyWith(grammar: value));
  });
}/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatEntryModelCopyWith<$Res> get vocabulary {
  
  return $StatEntryModelCopyWith<$Res>(_self.vocabulary, (value) {
    return _then(_self.copyWith(vocabulary: value));
  });
}/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatEntryModelCopyWith<$Res> get listening {
  
  return $StatEntryModelCopyWith<$Res>(_self.listening, (value) {
    return _then(_self.copyWith(listening: value));
  });
}/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatEntryModelCopyWith<$Res> get speaking {
  
  return $StatEntryModelCopyWith<$Res>(_self.speaking, (value) {
    return _then(_self.copyWith(speaking: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExerciseStatsModel].
extension ExerciseStatsModelPatterns on ExerciseStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseStatsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseStatsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseStatsModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseStatsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseStatsModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseStatsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StatEntryModel grammar,  StatEntryModel vocabulary,  StatEntryModel listening,  StatEntryModel speaking)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseStatsModel() when $default != null:
return $default(_that.grammar,_that.vocabulary,_that.listening,_that.speaking);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StatEntryModel grammar,  StatEntryModel vocabulary,  StatEntryModel listening,  StatEntryModel speaking)  $default,) {final _that = this;
switch (_that) {
case _ExerciseStatsModel():
return $default(_that.grammar,_that.vocabulary,_that.listening,_that.speaking);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StatEntryModel grammar,  StatEntryModel vocabulary,  StatEntryModel listening,  StatEntryModel speaking)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseStatsModel() when $default != null:
return $default(_that.grammar,_that.vocabulary,_that.listening,_that.speaking);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseStatsModel implements ExerciseStatsModel {
  const _ExerciseStatsModel({this.grammar = const StatEntryModel(), this.vocabulary = const StatEntryModel(), this.listening = const StatEntryModel(), this.speaking = const StatEntryModel()});
  factory _ExerciseStatsModel.fromJson(Map<String, dynamic> json) => _$ExerciseStatsModelFromJson(json);

@override@JsonKey() final  StatEntryModel grammar;
@override@JsonKey() final  StatEntryModel vocabulary;
@override@JsonKey() final  StatEntryModel listening;
@override@JsonKey() final  StatEntryModel speaking;

/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseStatsModelCopyWith<_ExerciseStatsModel> get copyWith => __$ExerciseStatsModelCopyWithImpl<_ExerciseStatsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseStatsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseStatsModel&&(identical(other.grammar, grammar) || other.grammar == grammar)&&(identical(other.vocabulary, vocabulary) || other.vocabulary == vocabulary)&&(identical(other.listening, listening) || other.listening == listening)&&(identical(other.speaking, speaking) || other.speaking == speaking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grammar,vocabulary,listening,speaking);

@override
String toString() {
  return 'ExerciseStatsModel(grammar: $grammar, vocabulary: $vocabulary, listening: $listening, speaking: $speaking)';
}


}

/// @nodoc
abstract mixin class _$ExerciseStatsModelCopyWith<$Res> implements $ExerciseStatsModelCopyWith<$Res> {
  factory _$ExerciseStatsModelCopyWith(_ExerciseStatsModel value, $Res Function(_ExerciseStatsModel) _then) = __$ExerciseStatsModelCopyWithImpl;
@override @useResult
$Res call({
 StatEntryModel grammar, StatEntryModel vocabulary, StatEntryModel listening, StatEntryModel speaking
});


@override $StatEntryModelCopyWith<$Res> get grammar;@override $StatEntryModelCopyWith<$Res> get vocabulary;@override $StatEntryModelCopyWith<$Res> get listening;@override $StatEntryModelCopyWith<$Res> get speaking;

}
/// @nodoc
class __$ExerciseStatsModelCopyWithImpl<$Res>
    implements _$ExerciseStatsModelCopyWith<$Res> {
  __$ExerciseStatsModelCopyWithImpl(this._self, this._then);

  final _ExerciseStatsModel _self;
  final $Res Function(_ExerciseStatsModel) _then;

/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? grammar = null,Object? vocabulary = null,Object? listening = null,Object? speaking = null,}) {
  return _then(_ExerciseStatsModel(
grammar: null == grammar ? _self.grammar : grammar // ignore: cast_nullable_to_non_nullable
as StatEntryModel,vocabulary: null == vocabulary ? _self.vocabulary : vocabulary // ignore: cast_nullable_to_non_nullable
as StatEntryModel,listening: null == listening ? _self.listening : listening // ignore: cast_nullable_to_non_nullable
as StatEntryModel,speaking: null == speaking ? _self.speaking : speaking // ignore: cast_nullable_to_non_nullable
as StatEntryModel,
  ));
}

/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatEntryModelCopyWith<$Res> get grammar {
  
  return $StatEntryModelCopyWith<$Res>(_self.grammar, (value) {
    return _then(_self.copyWith(grammar: value));
  });
}/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatEntryModelCopyWith<$Res> get vocabulary {
  
  return $StatEntryModelCopyWith<$Res>(_self.vocabulary, (value) {
    return _then(_self.copyWith(vocabulary: value));
  });
}/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatEntryModelCopyWith<$Res> get listening {
  
  return $StatEntryModelCopyWith<$Res>(_self.listening, (value) {
    return _then(_self.copyWith(listening: value));
  });
}/// Create a copy of ExerciseStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatEntryModelCopyWith<$Res> get speaking {
  
  return $StatEntryModelCopyWith<$Res>(_self.speaking, (value) {
    return _then(_self.copyWith(speaking: value));
  });
}
}

// dart format on
