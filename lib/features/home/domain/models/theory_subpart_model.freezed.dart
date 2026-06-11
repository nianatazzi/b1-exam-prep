// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theory_subpart_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TheorySubpartModel {

// id берётся из DocumentSnapshot.id — не хранится в теле документа
@JsonKey(includeToJson: false) String get id; int get number; String get topic;
/// Create a copy of TheorySubpartModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TheorySubpartModelCopyWith<TheorySubpartModel> get copyWith => _$TheorySubpartModelCopyWithImpl<TheorySubpartModel>(this as TheorySubpartModel, _$identity);

  /// Serializes this TheorySubpartModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TheorySubpartModel&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.topic, topic) || other.topic == topic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,topic);

@override
String toString() {
  return 'TheorySubpartModel(id: $id, number: $number, topic: $topic)';
}


}

/// @nodoc
abstract mixin class $TheorySubpartModelCopyWith<$Res>  {
  factory $TheorySubpartModelCopyWith(TheorySubpartModel value, $Res Function(TheorySubpartModel) _then) = _$TheorySubpartModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, int number, String topic
});




}
/// @nodoc
class _$TheorySubpartModelCopyWithImpl<$Res>
    implements $TheorySubpartModelCopyWith<$Res> {
  _$TheorySubpartModelCopyWithImpl(this._self, this._then);

  final TheorySubpartModel _self;
  final $Res Function(TheorySubpartModel) _then;

/// Create a copy of TheorySubpartModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? topic = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TheorySubpartModel].
extension TheorySubpartModelPatterns on TheorySubpartModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TheorySubpartModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TheorySubpartModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TheorySubpartModel value)  $default,){
final _that = this;
switch (_that) {
case _TheorySubpartModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TheorySubpartModel value)?  $default,){
final _that = this;
switch (_that) {
case _TheorySubpartModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  int number,  String topic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TheorySubpartModel() when $default != null:
return $default(_that.id,_that.number,_that.topic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  int number,  String topic)  $default,) {final _that = this;
switch (_that) {
case _TheorySubpartModel():
return $default(_that.id,_that.number,_that.topic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  int number,  String topic)?  $default,) {final _that = this;
switch (_that) {
case _TheorySubpartModel() when $default != null:
return $default(_that.id,_that.number,_that.topic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TheorySubpartModel implements TheorySubpartModel {
  const _TheorySubpartModel({@JsonKey(includeToJson: false) required this.id, required this.number, required this.topic});
  factory _TheorySubpartModel.fromJson(Map<String, dynamic> json) => _$TheorySubpartModelFromJson(json);

// id берётся из DocumentSnapshot.id — не хранится в теле документа
@override@JsonKey(includeToJson: false) final  String id;
@override final  int number;
@override final  String topic;

/// Create a copy of TheorySubpartModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TheorySubpartModelCopyWith<_TheorySubpartModel> get copyWith => __$TheorySubpartModelCopyWithImpl<_TheorySubpartModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TheorySubpartModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TheorySubpartModel&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.topic, topic) || other.topic == topic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,topic);

@override
String toString() {
  return 'TheorySubpartModel(id: $id, number: $number, topic: $topic)';
}


}

/// @nodoc
abstract mixin class _$TheorySubpartModelCopyWith<$Res> implements $TheorySubpartModelCopyWith<$Res> {
  factory _$TheorySubpartModelCopyWith(_TheorySubpartModel value, $Res Function(_TheorySubpartModel) _then) = __$TheorySubpartModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, int number, String topic
});




}
/// @nodoc
class __$TheorySubpartModelCopyWithImpl<$Res>
    implements _$TheorySubpartModelCopyWith<$Res> {
  __$TheorySubpartModelCopyWithImpl(this._self, this._then);

  final _TheorySubpartModel _self;
  final $Res Function(_TheorySubpartModel) _then;

/// Create a copy of TheorySubpartModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? topic = null,}) {
  return _then(_TheorySubpartModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
