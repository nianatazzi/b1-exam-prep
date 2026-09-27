// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialogue_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DialogueMessageModel {

 DialogueRole get role; String get text;
/// Create a copy of DialogueMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogueMessageModelCopyWith<DialogueMessageModel> get copyWith => _$DialogueMessageModelCopyWithImpl<DialogueMessageModel>(this as DialogueMessageModel, _$identity);

  /// Serializes this DialogueMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogueMessageModel&&(identical(other.role, role) || other.role == role)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,text);

@override
String toString() {
  return 'DialogueMessageModel(role: $role, text: $text)';
}


}

/// @nodoc
abstract mixin class $DialogueMessageModelCopyWith<$Res>  {
  factory $DialogueMessageModelCopyWith(DialogueMessageModel value, $Res Function(DialogueMessageModel) _then) = _$DialogueMessageModelCopyWithImpl;
@useResult
$Res call({
 DialogueRole role, String text
});




}
/// @nodoc
class _$DialogueMessageModelCopyWithImpl<$Res>
    implements $DialogueMessageModelCopyWith<$Res> {
  _$DialogueMessageModelCopyWithImpl(this._self, this._then);

  final DialogueMessageModel _self;
  final $Res Function(DialogueMessageModel) _then;

/// Create a copy of DialogueMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? text = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as DialogueRole,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DialogueMessageModel].
extension DialogueMessageModelPatterns on DialogueMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialogueMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialogueMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialogueMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _DialogueMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialogueMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _DialogueMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DialogueRole role,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DialogueMessageModel() when $default != null:
return $default(_that.role,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DialogueRole role,  String text)  $default,) {final _that = this;
switch (_that) {
case _DialogueMessageModel():
return $default(_that.role,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DialogueRole role,  String text)?  $default,) {final _that = this;
switch (_that) {
case _DialogueMessageModel() when $default != null:
return $default(_that.role,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DialogueMessageModel implements DialogueMessageModel {
  const _DialogueMessageModel({required this.role, required this.text});
  factory _DialogueMessageModel.fromJson(Map<String, dynamic> json) => _$DialogueMessageModelFromJson(json);

@override final  DialogueRole role;
@override final  String text;

/// Create a copy of DialogueMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogueMessageModelCopyWith<_DialogueMessageModel> get copyWith => __$DialogueMessageModelCopyWithImpl<_DialogueMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DialogueMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialogueMessageModel&&(identical(other.role, role) || other.role == role)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,text);

@override
String toString() {
  return 'DialogueMessageModel(role: $role, text: $text)';
}


}

/// @nodoc
abstract mixin class _$DialogueMessageModelCopyWith<$Res> implements $DialogueMessageModelCopyWith<$Res> {
  factory _$DialogueMessageModelCopyWith(_DialogueMessageModel value, $Res Function(_DialogueMessageModel) _then) = __$DialogueMessageModelCopyWithImpl;
@override @useResult
$Res call({
 DialogueRole role, String text
});




}
/// @nodoc
class __$DialogueMessageModelCopyWithImpl<$Res>
    implements _$DialogueMessageModelCopyWith<$Res> {
  __$DialogueMessageModelCopyWithImpl(this._self, this._then);

  final _DialogueMessageModel _self;
  final $Res Function(_DialogueMessageModel) _then;

/// Create a copy of DialogueMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? text = null,}) {
  return _then(_DialogueMessageModel(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as DialogueRole,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
