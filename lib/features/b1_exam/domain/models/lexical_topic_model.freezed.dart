// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lexical_topic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LexicalTopicModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'lt_id') int get ltId; String get title; String get description;
/// Create a copy of LexicalTopicModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LexicalTopicModelCopyWith<LexicalTopicModel> get copyWith => _$LexicalTopicModelCopyWithImpl<LexicalTopicModel>(this as LexicalTopicModel, _$identity);

  /// Serializes this LexicalTopicModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LexicalTopicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ltId, ltId) || other.ltId == ltId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ltId,title,description);

@override
String toString() {
  return 'LexicalTopicModel(id: $id, ltId: $ltId, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $LexicalTopicModelCopyWith<$Res>  {
  factory $LexicalTopicModelCopyWith(LexicalTopicModel value, $Res Function(LexicalTopicModel) _then) = _$LexicalTopicModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'lt_id') int ltId, String title, String description
});




}
/// @nodoc
class _$LexicalTopicModelCopyWithImpl<$Res>
    implements $LexicalTopicModelCopyWith<$Res> {
  _$LexicalTopicModelCopyWithImpl(this._self, this._then);

  final LexicalTopicModel _self;
  final $Res Function(LexicalTopicModel) _then;

/// Create a copy of LexicalTopicModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ltId = null,Object? title = null,Object? description = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ltId: null == ltId ? _self.ltId : ltId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LexicalTopicModel].
extension LexicalTopicModelPatterns on LexicalTopicModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LexicalTopicModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LexicalTopicModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LexicalTopicModel value)  $default,){
final _that = this;
switch (_that) {
case _LexicalTopicModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LexicalTopicModel value)?  $default,){
final _that = this;
switch (_that) {
case _LexicalTopicModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'lt_id')  int ltId,  String title,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LexicalTopicModel() when $default != null:
return $default(_that.id,_that.ltId,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'lt_id')  int ltId,  String title,  String description)  $default,) {final _that = this;
switch (_that) {
case _LexicalTopicModel():
return $default(_that.id,_that.ltId,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'lt_id')  int ltId,  String title,  String description)?  $default,) {final _that = this;
switch (_that) {
case _LexicalTopicModel() when $default != null:
return $default(_that.id,_that.ltId,_that.title,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LexicalTopicModel implements LexicalTopicModel {
  const _LexicalTopicModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'lt_id') required this.ltId, required this.title, this.description = ''});
  factory _LexicalTopicModel.fromJson(Map<String, dynamic> json) => _$LexicalTopicModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'lt_id') final  int ltId;
@override final  String title;
@override@JsonKey() final  String description;

/// Create a copy of LexicalTopicModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LexicalTopicModelCopyWith<_LexicalTopicModel> get copyWith => __$LexicalTopicModelCopyWithImpl<_LexicalTopicModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LexicalTopicModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LexicalTopicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ltId, ltId) || other.ltId == ltId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ltId,title,description);

@override
String toString() {
  return 'LexicalTopicModel(id: $id, ltId: $ltId, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class _$LexicalTopicModelCopyWith<$Res> implements $LexicalTopicModelCopyWith<$Res> {
  factory _$LexicalTopicModelCopyWith(_LexicalTopicModel value, $Res Function(_LexicalTopicModel) _then) = __$LexicalTopicModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'lt_id') int ltId, String title, String description
});




}
/// @nodoc
class __$LexicalTopicModelCopyWithImpl<$Res>
    implements _$LexicalTopicModelCopyWith<$Res> {
  __$LexicalTopicModelCopyWithImpl(this._self, this._then);

  final _LexicalTopicModel _self;
  final $Res Function(_LexicalTopicModel) _then;

/// Create a copy of LexicalTopicModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ltId = null,Object? title = null,Object? description = null,}) {
  return _then(_LexicalTopicModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ltId: null == ltId ? _self.ltId : ltId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
