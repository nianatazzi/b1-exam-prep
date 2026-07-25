// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic_progress_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TopicProgressModel {

@JsonKey(includeToJson: false) String get id; Map<String, StepResultModel> get topicResults; ExerciseStatsModel get stats; Map<String, AchievementModel> get achievements;
/// Create a copy of TopicProgressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicProgressModelCopyWith<TopicProgressModel> get copyWith => _$TopicProgressModelCopyWithImpl<TopicProgressModel>(this as TopicProgressModel, _$identity);

  /// Serializes this TopicProgressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicProgressModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.topicResults, topicResults)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other.achievements, achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(topicResults),stats,const DeepCollectionEquality().hash(achievements));

@override
String toString() {
  return 'TopicProgressModel(id: $id, topicResults: $topicResults, stats: $stats, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class $TopicProgressModelCopyWith<$Res>  {
  factory $TopicProgressModelCopyWith(TopicProgressModel value, $Res Function(TopicProgressModel) _then) = _$TopicProgressModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, Map<String, StepResultModel> topicResults, ExerciseStatsModel stats, Map<String, AchievementModel> achievements
});


$ExerciseStatsModelCopyWith<$Res> get stats;

}
/// @nodoc
class _$TopicProgressModelCopyWithImpl<$Res>
    implements $TopicProgressModelCopyWith<$Res> {
  _$TopicProgressModelCopyWithImpl(this._self, this._then);

  final TopicProgressModel _self;
  final $Res Function(TopicProgressModel) _then;

/// Create a copy of TopicProgressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? topicResults = null,Object? stats = null,Object? achievements = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,topicResults: null == topicResults ? _self.topicResults : topicResults // ignore: cast_nullable_to_non_nullable
as Map<String, StepResultModel>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ExerciseStatsModel,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as Map<String, AchievementModel>,
  ));
}
/// Create a copy of TopicProgressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseStatsModelCopyWith<$Res> get stats {
  
  return $ExerciseStatsModelCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [TopicProgressModel].
extension TopicProgressModelPatterns on TopicProgressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopicProgressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopicProgressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopicProgressModel value)  $default,){
final _that = this;
switch (_that) {
case _TopicProgressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopicProgressModel value)?  $default,){
final _that = this;
switch (_that) {
case _TopicProgressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  Map<String, StepResultModel> topicResults,  ExerciseStatsModel stats,  Map<String, AchievementModel> achievements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopicProgressModel() when $default != null:
return $default(_that.id,_that.topicResults,_that.stats,_that.achievements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  Map<String, StepResultModel> topicResults,  ExerciseStatsModel stats,  Map<String, AchievementModel> achievements)  $default,) {final _that = this;
switch (_that) {
case _TopicProgressModel():
return $default(_that.id,_that.topicResults,_that.stats,_that.achievements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  Map<String, StepResultModel> topicResults,  ExerciseStatsModel stats,  Map<String, AchievementModel> achievements)?  $default,) {final _that = this;
switch (_that) {
case _TopicProgressModel() when $default != null:
return $default(_that.id,_that.topicResults,_that.stats,_that.achievements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopicProgressModel implements TopicProgressModel {
  const _TopicProgressModel({@JsonKey(includeToJson: false) required this.id, final  Map<String, StepResultModel> topicResults = const <String, StepResultModel>{}, this.stats = const ExerciseStatsModel(), final  Map<String, AchievementModel> achievements = const <String, AchievementModel>{}}): _topicResults = topicResults,_achievements = achievements;
  factory _TopicProgressModel.fromJson(Map<String, dynamic> json) => _$TopicProgressModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
 final  Map<String, StepResultModel> _topicResults;
@override@JsonKey() Map<String, StepResultModel> get topicResults {
  if (_topicResults is EqualUnmodifiableMapView) return _topicResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_topicResults);
}

@override@JsonKey() final  ExerciseStatsModel stats;
 final  Map<String, AchievementModel> _achievements;
@override@JsonKey() Map<String, AchievementModel> get achievements {
  if (_achievements is EqualUnmodifiableMapView) return _achievements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_achievements);
}


/// Create a copy of TopicProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicProgressModelCopyWith<_TopicProgressModel> get copyWith => __$TopicProgressModelCopyWithImpl<_TopicProgressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicProgressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicProgressModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._topicResults, _topicResults)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other._achievements, _achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_topicResults),stats,const DeepCollectionEquality().hash(_achievements));

@override
String toString() {
  return 'TopicProgressModel(id: $id, topicResults: $topicResults, stats: $stats, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class _$TopicProgressModelCopyWith<$Res> implements $TopicProgressModelCopyWith<$Res> {
  factory _$TopicProgressModelCopyWith(_TopicProgressModel value, $Res Function(_TopicProgressModel) _then) = __$TopicProgressModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, Map<String, StepResultModel> topicResults, ExerciseStatsModel stats, Map<String, AchievementModel> achievements
});


@override $ExerciseStatsModelCopyWith<$Res> get stats;

}
/// @nodoc
class __$TopicProgressModelCopyWithImpl<$Res>
    implements _$TopicProgressModelCopyWith<$Res> {
  __$TopicProgressModelCopyWithImpl(this._self, this._then);

  final _TopicProgressModel _self;
  final $Res Function(_TopicProgressModel) _then;

/// Create a copy of TopicProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? topicResults = null,Object? stats = null,Object? achievements = null,}) {
  return _then(_TopicProgressModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,topicResults: null == topicResults ? _self._topicResults : topicResults // ignore: cast_nullable_to_non_nullable
as Map<String, StepResultModel>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ExerciseStatsModel,achievements: null == achievements ? _self._achievements : achievements // ignore: cast_nullable_to_non_nullable
as Map<String, AchievementModel>,
  ));
}

/// Create a copy of TopicProgressModel
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
