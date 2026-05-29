// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublicUserModel {

// id берётся из DocumentSnapshot.id — не хранится в теле документа
@JsonKey(includeToJson: false) String get id; String get name; String get surname; String? get avatar; int get points; Map<String, dynamic> get preference;
/// Create a copy of PublicUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicUserModelCopyWith<PublicUserModel> get copyWith => _$PublicUserModelCopyWithImpl<PublicUserModel>(this as PublicUserModel, _$identity);

  /// Serializes this PublicUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.surname, surname) || other.surname == surname)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.points, points) || other.points == points)&&const DeepCollectionEquality().equals(other.preference, preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,surname,avatar,points,const DeepCollectionEquality().hash(preference));

@override
String toString() {
  return 'PublicUserModel(id: $id, name: $name, surname: $surname, avatar: $avatar, points: $points, preference: $preference)';
}


}

/// @nodoc
abstract mixin class $PublicUserModelCopyWith<$Res>  {
  factory $PublicUserModelCopyWith(PublicUserModel value, $Res Function(PublicUserModel) _then) = _$PublicUserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, String surname, String? avatar, int points, Map<String, dynamic> preference
});




}
/// @nodoc
class _$PublicUserModelCopyWithImpl<$Res>
    implements $PublicUserModelCopyWith<$Res> {
  _$PublicUserModelCopyWithImpl(this._self, this._then);

  final PublicUserModel _self;
  final $Res Function(PublicUserModel) _then;

/// Create a copy of PublicUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? surname = null,Object? avatar = freezed,Object? points = null,Object? preference = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,surname: null == surname ? _self.surname : surname // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicUserModel].
extension PublicUserModelPatterns on PublicUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicUserModel value)  $default,){
final _that = this;
switch (_that) {
case _PublicUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _PublicUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  String surname,  String? avatar,  int points,  Map<String, dynamic> preference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicUserModel() when $default != null:
return $default(_that.id,_that.name,_that.surname,_that.avatar,_that.points,_that.preference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  String surname,  String? avatar,  int points,  Map<String, dynamic> preference)  $default,) {final _that = this;
switch (_that) {
case _PublicUserModel():
return $default(_that.id,_that.name,_that.surname,_that.avatar,_that.points,_that.preference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String name,  String surname,  String? avatar,  int points,  Map<String, dynamic> preference)?  $default,) {final _that = this;
switch (_that) {
case _PublicUserModel() when $default != null:
return $default(_that.id,_that.name,_that.surname,_that.avatar,_that.points,_that.preference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicUserModel implements PublicUserModel {
  const _PublicUserModel({@JsonKey(includeToJson: false) required this.id, required this.name, required this.surname, this.avatar, required this.points, final  Map<String, dynamic> preference = const <String, dynamic>{}}): _preference = preference;
  factory _PublicUserModel.fromJson(Map<String, dynamic> json) => _$PublicUserModelFromJson(json);

// id берётся из DocumentSnapshot.id — не хранится в теле документа
@override@JsonKey(includeToJson: false) final  String id;
@override final  String name;
@override final  String surname;
@override final  String? avatar;
@override final  int points;
 final  Map<String, dynamic> _preference;
@override@JsonKey() Map<String, dynamic> get preference {
  if (_preference is EqualUnmodifiableMapView) return _preference;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_preference);
}


/// Create a copy of PublicUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicUserModelCopyWith<_PublicUserModel> get copyWith => __$PublicUserModelCopyWithImpl<_PublicUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.surname, surname) || other.surname == surname)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.points, points) || other.points == points)&&const DeepCollectionEquality().equals(other._preference, _preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,surname,avatar,points,const DeepCollectionEquality().hash(_preference));

@override
String toString() {
  return 'PublicUserModel(id: $id, name: $name, surname: $surname, avatar: $avatar, points: $points, preference: $preference)';
}


}

/// @nodoc
abstract mixin class _$PublicUserModelCopyWith<$Res> implements $PublicUserModelCopyWith<$Res> {
  factory _$PublicUserModelCopyWith(_PublicUserModel value, $Res Function(_PublicUserModel) _then) = __$PublicUserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, String surname, String? avatar, int points, Map<String, dynamic> preference
});




}
/// @nodoc
class __$PublicUserModelCopyWithImpl<$Res>
    implements _$PublicUserModelCopyWith<$Res> {
  __$PublicUserModelCopyWithImpl(this._self, this._then);

  final _PublicUserModel _self;
  final $Res Function(_PublicUserModel) _then;

/// Create a copy of PublicUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? surname = null,Object? avatar = freezed,Object? points = null,Object? preference = null,}) {
  return _then(_PublicUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,surname: null == surname ? _self.surname : surname // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,preference: null == preference ? _self._preference : preference // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
