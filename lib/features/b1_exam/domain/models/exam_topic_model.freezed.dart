// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_topic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamTopicModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 't_id') int get tId; String get title; String get description;@JsonKey(name: 'image_url') String? get imageUrl;
/// Create a copy of ExamTopicModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamTopicModelCopyWith<ExamTopicModel> get copyWith => _$ExamTopicModelCopyWithImpl<ExamTopicModel>(this as ExamTopicModel, _$identity);

  /// Serializes this ExamTopicModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamTopicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.tId, tId) || other.tId == tId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tId,title,description,imageUrl);

@override
String toString() {
  return 'ExamTopicModel(id: $id, tId: $tId, title: $title, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $ExamTopicModelCopyWith<$Res>  {
  factory $ExamTopicModelCopyWith(ExamTopicModel value, $Res Function(ExamTopicModel) _then) = _$ExamTopicModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 't_id') int tId, String title, String description,@JsonKey(name: 'image_url') String? imageUrl
});




}
/// @nodoc
class _$ExamTopicModelCopyWithImpl<$Res>
    implements $ExamTopicModelCopyWith<$Res> {
  _$ExamTopicModelCopyWithImpl(this._self, this._then);

  final ExamTopicModel _self;
  final $Res Function(ExamTopicModel) _then;

/// Create a copy of ExamTopicModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tId = null,Object? title = null,Object? description = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tId: null == tId ? _self.tId : tId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamTopicModel].
extension ExamTopicModelPatterns on ExamTopicModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamTopicModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamTopicModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamTopicModel value)  $default,){
final _that = this;
switch (_that) {
case _ExamTopicModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamTopicModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExamTopicModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 't_id')  int tId,  String title,  String description, @JsonKey(name: 'image_url')  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamTopicModel() when $default != null:
return $default(_that.id,_that.tId,_that.title,_that.description,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 't_id')  int tId,  String title,  String description, @JsonKey(name: 'image_url')  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _ExamTopicModel():
return $default(_that.id,_that.tId,_that.title,_that.description,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 't_id')  int tId,  String title,  String description, @JsonKey(name: 'image_url')  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _ExamTopicModel() when $default != null:
return $default(_that.id,_that.tId,_that.title,_that.description,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamTopicModel implements ExamTopicModel {
  const _ExamTopicModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 't_id') required this.tId, required this.title, this.description = '', @JsonKey(name: 'image_url') this.imageUrl});
  factory _ExamTopicModel.fromJson(Map<String, dynamic> json) => _$ExamTopicModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 't_id') final  int tId;
@override final  String title;
@override@JsonKey() final  String description;
@override@JsonKey(name: 'image_url') final  String? imageUrl;

/// Create a copy of ExamTopicModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamTopicModelCopyWith<_ExamTopicModel> get copyWith => __$ExamTopicModelCopyWithImpl<_ExamTopicModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamTopicModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamTopicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.tId, tId) || other.tId == tId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tId,title,description,imageUrl);

@override
String toString() {
  return 'ExamTopicModel(id: $id, tId: $tId, title: $title, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$ExamTopicModelCopyWith<$Res> implements $ExamTopicModelCopyWith<$Res> {
  factory _$ExamTopicModelCopyWith(_ExamTopicModel value, $Res Function(_ExamTopicModel) _then) = __$ExamTopicModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 't_id') int tId, String title, String description,@JsonKey(name: 'image_url') String? imageUrl
});




}
/// @nodoc
class __$ExamTopicModelCopyWithImpl<$Res>
    implements _$ExamTopicModelCopyWith<$Res> {
  __$ExamTopicModelCopyWithImpl(this._self, this._then);

  final _ExamTopicModel _self;
  final $Res Function(_ExamTopicModel) _then;

/// Create a copy of ExamTopicModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tId = null,Object? title = null,Object? description = null,Object? imageUrl = freezed,}) {
  return _then(_ExamTopicModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tId: null == tId ? _self.tId : tId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
