// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialogue_scenario_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DialogueScenarioModel {

 Map<String, dynamic> get situation;@JsonKey(name: 'user_role') Map<String, dynamic> get userRole;@JsonKey(name: 'ai_role') Map<String, dynamic> get aiRole; Map<String, dynamic> get goal;@JsonKey(name: 'opening_line') String get openingLine;@JsonKey(name: 'max_turns') int get maxTurns;
/// Create a copy of DialogueScenarioModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogueScenarioModelCopyWith<DialogueScenarioModel> get copyWith => _$DialogueScenarioModelCopyWithImpl<DialogueScenarioModel>(this as DialogueScenarioModel, _$identity);

  /// Serializes this DialogueScenarioModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogueScenarioModel&&const DeepCollectionEquality().equals(other.situation, situation)&&const DeepCollectionEquality().equals(other.userRole, userRole)&&const DeepCollectionEquality().equals(other.aiRole, aiRole)&&const DeepCollectionEquality().equals(other.goal, goal)&&(identical(other.openingLine, openingLine) || other.openingLine == openingLine)&&(identical(other.maxTurns, maxTurns) || other.maxTurns == maxTurns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(situation),const DeepCollectionEquality().hash(userRole),const DeepCollectionEquality().hash(aiRole),const DeepCollectionEquality().hash(goal),openingLine,maxTurns);

@override
String toString() {
  return 'DialogueScenarioModel(situation: $situation, userRole: $userRole, aiRole: $aiRole, goal: $goal, openingLine: $openingLine, maxTurns: $maxTurns)';
}


}

/// @nodoc
abstract mixin class $DialogueScenarioModelCopyWith<$Res>  {
  factory $DialogueScenarioModelCopyWith(DialogueScenarioModel value, $Res Function(DialogueScenarioModel) _then) = _$DialogueScenarioModelCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> situation,@JsonKey(name: 'user_role') Map<String, dynamic> userRole,@JsonKey(name: 'ai_role') Map<String, dynamic> aiRole, Map<String, dynamic> goal,@JsonKey(name: 'opening_line') String openingLine,@JsonKey(name: 'max_turns') int maxTurns
});




}
/// @nodoc
class _$DialogueScenarioModelCopyWithImpl<$Res>
    implements $DialogueScenarioModelCopyWith<$Res> {
  _$DialogueScenarioModelCopyWithImpl(this._self, this._then);

  final DialogueScenarioModel _self;
  final $Res Function(DialogueScenarioModel) _then;

/// Create a copy of DialogueScenarioModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? situation = null,Object? userRole = null,Object? aiRole = null,Object? goal = null,Object? openingLine = null,Object? maxTurns = null,}) {
  return _then(_self.copyWith(
situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,aiRole: null == aiRole ? _self.aiRole : aiRole // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,openingLine: null == openingLine ? _self.openingLine : openingLine // ignore: cast_nullable_to_non_nullable
as String,maxTurns: null == maxTurns ? _self.maxTurns : maxTurns // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DialogueScenarioModel].
extension DialogueScenarioModelPatterns on DialogueScenarioModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialogueScenarioModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialogueScenarioModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialogueScenarioModel value)  $default,){
final _that = this;
switch (_that) {
case _DialogueScenarioModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialogueScenarioModel value)?  $default,){
final _that = this;
switch (_that) {
case _DialogueScenarioModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> situation, @JsonKey(name: 'user_role')  Map<String, dynamic> userRole, @JsonKey(name: 'ai_role')  Map<String, dynamic> aiRole,  Map<String, dynamic> goal, @JsonKey(name: 'opening_line')  String openingLine, @JsonKey(name: 'max_turns')  int maxTurns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DialogueScenarioModel() when $default != null:
return $default(_that.situation,_that.userRole,_that.aiRole,_that.goal,_that.openingLine,_that.maxTurns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> situation, @JsonKey(name: 'user_role')  Map<String, dynamic> userRole, @JsonKey(name: 'ai_role')  Map<String, dynamic> aiRole,  Map<String, dynamic> goal, @JsonKey(name: 'opening_line')  String openingLine, @JsonKey(name: 'max_turns')  int maxTurns)  $default,) {final _that = this;
switch (_that) {
case _DialogueScenarioModel():
return $default(_that.situation,_that.userRole,_that.aiRole,_that.goal,_that.openingLine,_that.maxTurns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> situation, @JsonKey(name: 'user_role')  Map<String, dynamic> userRole, @JsonKey(name: 'ai_role')  Map<String, dynamic> aiRole,  Map<String, dynamic> goal, @JsonKey(name: 'opening_line')  String openingLine, @JsonKey(name: 'max_turns')  int maxTurns)?  $default,) {final _that = this;
switch (_that) {
case _DialogueScenarioModel() when $default != null:
return $default(_that.situation,_that.userRole,_that.aiRole,_that.goal,_that.openingLine,_that.maxTurns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DialogueScenarioModel implements DialogueScenarioModel {
  const _DialogueScenarioModel({final  Map<String, dynamic> situation = const <String, dynamic>{}, @JsonKey(name: 'user_role') final  Map<String, dynamic> userRole = const <String, dynamic>{}, @JsonKey(name: 'ai_role') final  Map<String, dynamic> aiRole = const <String, dynamic>{}, final  Map<String, dynamic> goal = const <String, dynamic>{}, @JsonKey(name: 'opening_line') this.openingLine = '', @JsonKey(name: 'max_turns') this.maxTurns = 10}): _situation = situation,_userRole = userRole,_aiRole = aiRole,_goal = goal;
  factory _DialogueScenarioModel.fromJson(Map<String, dynamic> json) => _$DialogueScenarioModelFromJson(json);

 final  Map<String, dynamic> _situation;
@override@JsonKey() Map<String, dynamic> get situation {
  if (_situation is EqualUnmodifiableMapView) return _situation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_situation);
}

 final  Map<String, dynamic> _userRole;
@override@JsonKey(name: 'user_role') Map<String, dynamic> get userRole {
  if (_userRole is EqualUnmodifiableMapView) return _userRole;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_userRole);
}

 final  Map<String, dynamic> _aiRole;
@override@JsonKey(name: 'ai_role') Map<String, dynamic> get aiRole {
  if (_aiRole is EqualUnmodifiableMapView) return _aiRole;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_aiRole);
}

 final  Map<String, dynamic> _goal;
@override@JsonKey() Map<String, dynamic> get goal {
  if (_goal is EqualUnmodifiableMapView) return _goal;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_goal);
}

@override@JsonKey(name: 'opening_line') final  String openingLine;
@override@JsonKey(name: 'max_turns') final  int maxTurns;

/// Create a copy of DialogueScenarioModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogueScenarioModelCopyWith<_DialogueScenarioModel> get copyWith => __$DialogueScenarioModelCopyWithImpl<_DialogueScenarioModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DialogueScenarioModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialogueScenarioModel&&const DeepCollectionEquality().equals(other._situation, _situation)&&const DeepCollectionEquality().equals(other._userRole, _userRole)&&const DeepCollectionEquality().equals(other._aiRole, _aiRole)&&const DeepCollectionEquality().equals(other._goal, _goal)&&(identical(other.openingLine, openingLine) || other.openingLine == openingLine)&&(identical(other.maxTurns, maxTurns) || other.maxTurns == maxTurns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_situation),const DeepCollectionEquality().hash(_userRole),const DeepCollectionEquality().hash(_aiRole),const DeepCollectionEquality().hash(_goal),openingLine,maxTurns);

@override
String toString() {
  return 'DialogueScenarioModel(situation: $situation, userRole: $userRole, aiRole: $aiRole, goal: $goal, openingLine: $openingLine, maxTurns: $maxTurns)';
}


}

/// @nodoc
abstract mixin class _$DialogueScenarioModelCopyWith<$Res> implements $DialogueScenarioModelCopyWith<$Res> {
  factory _$DialogueScenarioModelCopyWith(_DialogueScenarioModel value, $Res Function(_DialogueScenarioModel) _then) = __$DialogueScenarioModelCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> situation,@JsonKey(name: 'user_role') Map<String, dynamic> userRole,@JsonKey(name: 'ai_role') Map<String, dynamic> aiRole, Map<String, dynamic> goal,@JsonKey(name: 'opening_line') String openingLine,@JsonKey(name: 'max_turns') int maxTurns
});




}
/// @nodoc
class __$DialogueScenarioModelCopyWithImpl<$Res>
    implements _$DialogueScenarioModelCopyWith<$Res> {
  __$DialogueScenarioModelCopyWithImpl(this._self, this._then);

  final _DialogueScenarioModel _self;
  final $Res Function(_DialogueScenarioModel) _then;

/// Create a copy of DialogueScenarioModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? situation = null,Object? userRole = null,Object? aiRole = null,Object? goal = null,Object? openingLine = null,Object? maxTurns = null,}) {
  return _then(_DialogueScenarioModel(
situation: null == situation ? _self._situation : situation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,userRole: null == userRole ? _self._userRole : userRole // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,aiRole: null == aiRole ? _self._aiRole : aiRole // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,goal: null == goal ? _self._goal : goal // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,openingLine: null == openingLine ? _self.openingLine : openingLine // ignore: cast_nullable_to_non_nullable
as String,maxTurns: null == maxTurns ? _self.maxTurns : maxTurns // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
