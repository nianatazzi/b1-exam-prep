// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageTaskModel {

@JsonKey(name: 'image_url') String get imageUrl;
/// Create a copy of ImageTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageTaskModelCopyWith<ImageTaskModel> get copyWith => _$ImageTaskModelCopyWithImpl<ImageTaskModel>(this as ImageTaskModel, _$identity);

  /// Serializes this ImageTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageTaskModel&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl);

@override
String toString() {
  return 'ImageTaskModel(imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $ImageTaskModelCopyWith<$Res>  {
  factory $ImageTaskModelCopyWith(ImageTaskModel value, $Res Function(ImageTaskModel) _then) = _$ImageTaskModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class _$ImageTaskModelCopyWithImpl<$Res>
    implements $ImageTaskModelCopyWith<$Res> {
  _$ImageTaskModelCopyWithImpl(this._self, this._then);

  final ImageTaskModel _self;
  final $Res Function(ImageTaskModel) _then;

/// Create a copy of ImageTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = null,}) {
  return _then(_self.copyWith(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageTaskModel].
extension ImageTaskModelPatterns on ImageTaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageTaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _ImageTaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImageTaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'image_url')  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageTaskModel() when $default != null:
return $default(_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'image_url')  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _ImageTaskModel():
return $default(_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'image_url')  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _ImageTaskModel() when $default != null:
return $default(_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageTaskModel implements ImageTaskModel {
  const _ImageTaskModel({@JsonKey(name: 'image_url') this.imageUrl = ''});
  factory _ImageTaskModel.fromJson(Map<String, dynamic> json) => _$ImageTaskModelFromJson(json);

@override@JsonKey(name: 'image_url') final  String imageUrl;

/// Create a copy of ImageTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageTaskModelCopyWith<_ImageTaskModel> get copyWith => __$ImageTaskModelCopyWithImpl<_ImageTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageTaskModel&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl);

@override
String toString() {
  return 'ImageTaskModel(imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$ImageTaskModelCopyWith<$Res> implements $ImageTaskModelCopyWith<$Res> {
  factory _$ImageTaskModelCopyWith(_ImageTaskModel value, $Res Function(_ImageTaskModel) _then) = __$ImageTaskModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class __$ImageTaskModelCopyWithImpl<$Res>
    implements _$ImageTaskModelCopyWith<$Res> {
  __$ImageTaskModelCopyWithImpl(this._self, this._then);

  final _ImageTaskModel _self;
  final $Res Function(_ImageTaskModel) _then;

/// Create a copy of ImageTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageUrl = null,}) {
  return _then(_ImageTaskModel(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
