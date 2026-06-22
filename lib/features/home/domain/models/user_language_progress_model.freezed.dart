// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_language_progress_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserLanguageProgressModel {

@JsonKey(includeToJson: false) String get id; String? get lastLesson; int get lastParagraph; ExerciseStatsModel get stats; Map<String, StepResultModel> get stepResults; Map<String, AchievementModel> get achievements;
/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLanguageProgressModelCopyWith<UserLanguageProgressModel> get copyWith => _$UserLanguageProgressModelCopyWithImpl<UserLanguageProgressModel>(this as UserLanguageProgressModel, _$identity);

  /// Serializes this UserLanguageProgressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLanguageProgressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.lastLesson, lastLesson) || other.lastLesson == lastLesson)&&(identical(other.lastParagraph, lastParagraph) || other.lastParagraph == lastParagraph)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other.stepResults, stepResults)&&const DeepCollectionEquality().equals(other.achievements, achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lastLesson,lastParagraph,stats,const DeepCollectionEquality().hash(stepResults),const DeepCollectionEquality().hash(achievements));

@override
String toString() {
  return 'UserLanguageProgressModel(id: $id, lastLesson: $lastLesson, lastParagraph: $lastParagraph, stats: $stats, stepResults: $stepResults, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class $UserLanguageProgressModelCopyWith<$Res>  {
  factory $UserLanguageProgressModelCopyWith(UserLanguageProgressModel value, $Res Function(UserLanguageProgressModel) _then) = _$UserLanguageProgressModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String? lastLesson, int lastParagraph, ExerciseStatsModel stats, Map<String, StepResultModel> stepResults, Map<String, AchievementModel> achievements
});


$ExerciseStatsModelCopyWith<$Res> get stats;

}
/// @nodoc
class _$UserLanguageProgressModelCopyWithImpl<$Res>
    implements $UserLanguageProgressModelCopyWith<$Res> {
  _$UserLanguageProgressModelCopyWithImpl(this._self, this._then);

  final UserLanguageProgressModel _self;
  final $Res Function(UserLanguageProgressModel) _then;

/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lastLesson = freezed,Object? lastParagraph = null,Object? stats = null,Object? stepResults = null,Object? achievements = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lastLesson: freezed == lastLesson ? _self.lastLesson : lastLesson // ignore: cast_nullable_to_non_nullable
as String?,lastParagraph: null == lastParagraph ? _self.lastParagraph : lastParagraph // ignore: cast_nullable_to_non_nullable
as int,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ExerciseStatsModel,stepResults: null == stepResults ? _self.stepResults : stepResults // ignore: cast_nullable_to_non_nullable
as Map<String, StepResultModel>,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as Map<String, AchievementModel>,
  ));
}
/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseStatsModelCopyWith<$Res> get stats {
  
  return $ExerciseStatsModelCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserLanguageProgressModel].
extension UserLanguageProgressModelPatterns on UserLanguageProgressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLanguageProgressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLanguageProgressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLanguageProgressModel value)  $default,){
final _that = this;
switch (_that) {
case _UserLanguageProgressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLanguageProgressModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserLanguageProgressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String? lastLesson,  int lastParagraph,  ExerciseStatsModel stats,  Map<String, StepResultModel> stepResults,  Map<String, AchievementModel> achievements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLanguageProgressModel() when $default != null:
return $default(_that.id,_that.lastLesson,_that.lastParagraph,_that.stats,_that.stepResults,_that.achievements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String? lastLesson,  int lastParagraph,  ExerciseStatsModel stats,  Map<String, StepResultModel> stepResults,  Map<String, AchievementModel> achievements)  $default,) {final _that = this;
switch (_that) {
case _UserLanguageProgressModel():
return $default(_that.id,_that.lastLesson,_that.lastParagraph,_that.stats,_that.stepResults,_that.achievements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String? lastLesson,  int lastParagraph,  ExerciseStatsModel stats,  Map<String, StepResultModel> stepResults,  Map<String, AchievementModel> achievements)?  $default,) {final _that = this;
switch (_that) {
case _UserLanguageProgressModel() when $default != null:
return $default(_that.id,_that.lastLesson,_that.lastParagraph,_that.stats,_that.stepResults,_that.achievements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserLanguageProgressModel implements UserLanguageProgressModel {
  const _UserLanguageProgressModel({@JsonKey(includeToJson: false) required this.id, this.lastLesson, required this.lastParagraph, this.stats = const ExerciseStatsModel(), final  Map<String, StepResultModel> stepResults = const <String, StepResultModel>{}, final  Map<String, AchievementModel> achievements = const <String, AchievementModel>{}}): _stepResults = stepResults,_achievements = achievements;
  factory _UserLanguageProgressModel.fromJson(Map<String, dynamic> json) => _$UserLanguageProgressModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String? lastLesson;
@override final  int lastParagraph;
@override@JsonKey() final  ExerciseStatsModel stats;
 final  Map<String, StepResultModel> _stepResults;
@override@JsonKey() Map<String, StepResultModel> get stepResults {
  if (_stepResults is EqualUnmodifiableMapView) return _stepResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stepResults);
}

 final  Map<String, AchievementModel> _achievements;
@override@JsonKey() Map<String, AchievementModel> get achievements {
  if (_achievements is EqualUnmodifiableMapView) return _achievements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_achievements);
}


/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLanguageProgressModelCopyWith<_UserLanguageProgressModel> get copyWith => __$UserLanguageProgressModelCopyWithImpl<_UserLanguageProgressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserLanguageProgressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLanguageProgressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.lastLesson, lastLesson) || other.lastLesson == lastLesson)&&(identical(other.lastParagraph, lastParagraph) || other.lastParagraph == lastParagraph)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other._stepResults, _stepResults)&&const DeepCollectionEquality().equals(other._achievements, _achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lastLesson,lastParagraph,stats,const DeepCollectionEquality().hash(_stepResults),const DeepCollectionEquality().hash(_achievements));

@override
String toString() {
  return 'UserLanguageProgressModel(id: $id, lastLesson: $lastLesson, lastParagraph: $lastParagraph, stats: $stats, stepResults: $stepResults, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class _$UserLanguageProgressModelCopyWith<$Res> implements $UserLanguageProgressModelCopyWith<$Res> {
  factory _$UserLanguageProgressModelCopyWith(_UserLanguageProgressModel value, $Res Function(_UserLanguageProgressModel) _then) = __$UserLanguageProgressModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String? lastLesson, int lastParagraph, ExerciseStatsModel stats, Map<String, StepResultModel> stepResults, Map<String, AchievementModel> achievements
});


@override $ExerciseStatsModelCopyWith<$Res> get stats;

}
/// @nodoc
class __$UserLanguageProgressModelCopyWithImpl<$Res>
    implements _$UserLanguageProgressModelCopyWith<$Res> {
  __$UserLanguageProgressModelCopyWithImpl(this._self, this._then);

  final _UserLanguageProgressModel _self;
  final $Res Function(_UserLanguageProgressModel) _then;

/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lastLesson = freezed,Object? lastParagraph = null,Object? stats = null,Object? stepResults = null,Object? achievements = null,}) {
  return _then(_UserLanguageProgressModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lastLesson: freezed == lastLesson ? _self.lastLesson : lastLesson // ignore: cast_nullable_to_non_nullable
as String?,lastParagraph: null == lastParagraph ? _self.lastParagraph : lastParagraph // ignore: cast_nullable_to_non_nullable
as int,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ExerciseStatsModel,stepResults: null == stepResults ? _self._stepResults : stepResults // ignore: cast_nullable_to_non_nullable
as Map<String, StepResultModel>,achievements: null == achievements ? _self._achievements : achievements // ignore: cast_nullable_to_non_nullable
as Map<String, AchievementModel>,
  ));
}

/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseStatsModelCopyWith<$Res> get stats {
  
  return $ExerciseStatsModelCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

// dart format on
