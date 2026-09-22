// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grammar_topic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrammarTopicModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'gt_id') int get gtId; String get title; String get description;
/// Create a copy of GrammarTopicModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarTopicModelCopyWith<GrammarTopicModel> get copyWith => _$GrammarTopicModelCopyWithImpl<GrammarTopicModel>(this as GrammarTopicModel, _$identity);

  /// Serializes this GrammarTopicModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarTopicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gtId, gtId) || other.gtId == gtId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gtId,title,description);

@override
String toString() {
  return 'GrammarTopicModel(id: $id, gtId: $gtId, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $GrammarTopicModelCopyWith<$Res>  {
  factory $GrammarTopicModelCopyWith(GrammarTopicModel value, $Res Function(GrammarTopicModel) _then) = _$GrammarTopicModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'gt_id') int gtId, String title, String description
});




}
/// @nodoc
class _$GrammarTopicModelCopyWithImpl<$Res>
    implements $GrammarTopicModelCopyWith<$Res> {
  _$GrammarTopicModelCopyWithImpl(this._self, this._then);

  final GrammarTopicModel _self;
  final $Res Function(GrammarTopicModel) _then;

/// Create a copy of GrammarTopicModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gtId = null,Object? title = null,Object? description = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gtId: null == gtId ? _self.gtId : gtId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarTopicModel].
extension GrammarTopicModelPatterns on GrammarTopicModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarTopicModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarTopicModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarTopicModel value)  $default,){
final _that = this;
switch (_that) {
case _GrammarTopicModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarTopicModel value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarTopicModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'gt_id')  int gtId,  String title,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarTopicModel() when $default != null:
return $default(_that.id,_that.gtId,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'gt_id')  int gtId,  String title,  String description)  $default,) {final _that = this;
switch (_that) {
case _GrammarTopicModel():
return $default(_that.id,_that.gtId,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'gt_id')  int gtId,  String title,  String description)?  $default,) {final _that = this;
switch (_that) {
case _GrammarTopicModel() when $default != null:
return $default(_that.id,_that.gtId,_that.title,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarTopicModel implements GrammarTopicModel {
  const _GrammarTopicModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'gt_id') required this.gtId, required this.title, this.description = ''});
  factory _GrammarTopicModel.fromJson(Map<String, dynamic> json) => _$GrammarTopicModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'gt_id') final  int gtId;
@override final  String title;
@override@JsonKey() final  String description;

/// Create a copy of GrammarTopicModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarTopicModelCopyWith<_GrammarTopicModel> get copyWith => __$GrammarTopicModelCopyWithImpl<_GrammarTopicModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarTopicModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarTopicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gtId, gtId) || other.gtId == gtId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gtId,title,description);

@override
String toString() {
  return 'GrammarTopicModel(id: $id, gtId: $gtId, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class _$GrammarTopicModelCopyWith<$Res> implements $GrammarTopicModelCopyWith<$Res> {
  factory _$GrammarTopicModelCopyWith(_GrammarTopicModel value, $Res Function(_GrammarTopicModel) _then) = __$GrammarTopicModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'gt_id') int gtId, String title, String description
});




}
/// @nodoc
class __$GrammarTopicModelCopyWithImpl<$Res>
    implements _$GrammarTopicModelCopyWith<$Res> {
  __$GrammarTopicModelCopyWithImpl(this._self, this._then);

  final _GrammarTopicModel _self;
  final $Res Function(_GrammarTopicModel) _then;

/// Create a copy of GrammarTopicModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gtId = null,Object? title = null,Object? description = null,}) {
  return _then(_GrammarTopicModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gtId: null == gtId ? _self.gtId : gtId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
