// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialogue_turn_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DialogueTurnResultModel {

 String get reply;@JsonKey(name: 'turnsLeft') int get turnsLeft;@JsonKey(name: 'shouldClose') bool get shouldClose;
/// Create a copy of DialogueTurnResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogueTurnResultModelCopyWith<DialogueTurnResultModel> get copyWith => _$DialogueTurnResultModelCopyWithImpl<DialogueTurnResultModel>(this as DialogueTurnResultModel, _$identity);

  /// Serializes this DialogueTurnResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogueTurnResultModel&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.turnsLeft, turnsLeft) || other.turnsLeft == turnsLeft)&&(identical(other.shouldClose, shouldClose) || other.shouldClose == shouldClose));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reply,turnsLeft,shouldClose);

@override
String toString() {
  return 'DialogueTurnResultModel(reply: $reply, turnsLeft: $turnsLeft, shouldClose: $shouldClose)';
}


}

/// @nodoc
abstract mixin class $DialogueTurnResultModelCopyWith<$Res>  {
  factory $DialogueTurnResultModelCopyWith(DialogueTurnResultModel value, $Res Function(DialogueTurnResultModel) _then) = _$DialogueTurnResultModelCopyWithImpl;
@useResult
$Res call({
 String reply,@JsonKey(name: 'turnsLeft') int turnsLeft,@JsonKey(name: 'shouldClose') bool shouldClose
});




}
/// @nodoc
class _$DialogueTurnResultModelCopyWithImpl<$Res>
    implements $DialogueTurnResultModelCopyWith<$Res> {
  _$DialogueTurnResultModelCopyWithImpl(this._self, this._then);

  final DialogueTurnResultModel _self;
  final $Res Function(DialogueTurnResultModel) _then;

/// Create a copy of DialogueTurnResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reply = null,Object? turnsLeft = null,Object? shouldClose = null,}) {
  return _then(_self.copyWith(
reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,turnsLeft: null == turnsLeft ? _self.turnsLeft : turnsLeft // ignore: cast_nullable_to_non_nullable
as int,shouldClose: null == shouldClose ? _self.shouldClose : shouldClose // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DialogueTurnResultModel].
extension DialogueTurnResultModelPatterns on DialogueTurnResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialogueTurnResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialogueTurnResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialogueTurnResultModel value)  $default,){
final _that = this;
switch (_that) {
case _DialogueTurnResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialogueTurnResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _DialogueTurnResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reply, @JsonKey(name: 'turnsLeft')  int turnsLeft, @JsonKey(name: 'shouldClose')  bool shouldClose)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DialogueTurnResultModel() when $default != null:
return $default(_that.reply,_that.turnsLeft,_that.shouldClose);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reply, @JsonKey(name: 'turnsLeft')  int turnsLeft, @JsonKey(name: 'shouldClose')  bool shouldClose)  $default,) {final _that = this;
switch (_that) {
case _DialogueTurnResultModel():
return $default(_that.reply,_that.turnsLeft,_that.shouldClose);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reply, @JsonKey(name: 'turnsLeft')  int turnsLeft, @JsonKey(name: 'shouldClose')  bool shouldClose)?  $default,) {final _that = this;
switch (_that) {
case _DialogueTurnResultModel() when $default != null:
return $default(_that.reply,_that.turnsLeft,_that.shouldClose);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DialogueTurnResultModel implements DialogueTurnResultModel {
  const _DialogueTurnResultModel({this.reply = '', @JsonKey(name: 'turnsLeft') this.turnsLeft = 0, @JsonKey(name: 'shouldClose') this.shouldClose = false});
  factory _DialogueTurnResultModel.fromJson(Map<String, dynamic> json) => _$DialogueTurnResultModelFromJson(json);

@override@JsonKey() final  String reply;
@override@JsonKey(name: 'turnsLeft') final  int turnsLeft;
@override@JsonKey(name: 'shouldClose') final  bool shouldClose;

/// Create a copy of DialogueTurnResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogueTurnResultModelCopyWith<_DialogueTurnResultModel> get copyWith => __$DialogueTurnResultModelCopyWithImpl<_DialogueTurnResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DialogueTurnResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialogueTurnResultModel&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.turnsLeft, turnsLeft) || other.turnsLeft == turnsLeft)&&(identical(other.shouldClose, shouldClose) || other.shouldClose == shouldClose));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reply,turnsLeft,shouldClose);

@override
String toString() {
  return 'DialogueTurnResultModel(reply: $reply, turnsLeft: $turnsLeft, shouldClose: $shouldClose)';
}


}

/// @nodoc
abstract mixin class _$DialogueTurnResultModelCopyWith<$Res> implements $DialogueTurnResultModelCopyWith<$Res> {
  factory _$DialogueTurnResultModelCopyWith(_DialogueTurnResultModel value, $Res Function(_DialogueTurnResultModel) _then) = __$DialogueTurnResultModelCopyWithImpl;
@override @useResult
$Res call({
 String reply,@JsonKey(name: 'turnsLeft') int turnsLeft,@JsonKey(name: 'shouldClose') bool shouldClose
});




}
/// @nodoc
class __$DialogueTurnResultModelCopyWithImpl<$Res>
    implements _$DialogueTurnResultModelCopyWith<$Res> {
  __$DialogueTurnResultModelCopyWithImpl(this._self, this._then);

  final _DialogueTurnResultModel _self;
  final $Res Function(_DialogueTurnResultModel) _then;

/// Create a copy of DialogueTurnResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reply = null,Object? turnsLeft = null,Object? shouldClose = null,}) {
  return _then(_DialogueTurnResultModel(
reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,turnsLeft: null == turnsLeft ? _self.turnsLeft : turnsLeft // ignore: cast_nullable_to_non_nullable
as int,shouldClose: null == shouldClose ? _self.shouldClose : shouldClose // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
