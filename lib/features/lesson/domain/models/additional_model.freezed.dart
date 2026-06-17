// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'additional_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdditionalModel {

@JsonKey(includeToJson: false) String get id; String get type; String get title; String get content;
/// Create a copy of AdditionalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdditionalModelCopyWith<AdditionalModel> get copyWith => _$AdditionalModelCopyWithImpl<AdditionalModel>(this as AdditionalModel, _$identity);

  /// Serializes this AdditionalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdditionalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,content);

@override
String toString() {
  return 'AdditionalModel(id: $id, type: $type, title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class $AdditionalModelCopyWith<$Res>  {
  factory $AdditionalModelCopyWith(AdditionalModel value, $Res Function(AdditionalModel) _then) = _$AdditionalModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String type, String title, String content
});




}
/// @nodoc
class _$AdditionalModelCopyWithImpl<$Res>
    implements $AdditionalModelCopyWith<$Res> {
  _$AdditionalModelCopyWithImpl(this._self, this._then);

  final AdditionalModel _self;
  final $Res Function(AdditionalModel) _then;

/// Create a copy of AdditionalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? content = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdditionalModel].
extension AdditionalModelPatterns on AdditionalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdditionalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdditionalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdditionalModel value)  $default,){
final _that = this;
switch (_that) {
case _AdditionalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdditionalModel value)?  $default,){
final _that = this;
switch (_that) {
case _AdditionalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String type,  String title,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdditionalModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String type,  String title,  String content)  $default,) {final _that = this;
switch (_that) {
case _AdditionalModel():
return $default(_that.id,_that.type,_that.title,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String type,  String title,  String content)?  $default,) {final _that = this;
switch (_that) {
case _AdditionalModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdditionalModel implements AdditionalModel {
  const _AdditionalModel({@JsonKey(includeToJson: false) required this.id, required this.type, required this.title, required this.content});
  factory _AdditionalModel.fromJson(Map<String, dynamic> json) => _$AdditionalModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String type;
@override final  String title;
@override final  String content;

/// Create a copy of AdditionalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdditionalModelCopyWith<_AdditionalModel> get copyWith => __$AdditionalModelCopyWithImpl<_AdditionalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdditionalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdditionalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,content);

@override
String toString() {
  return 'AdditionalModel(id: $id, type: $type, title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class _$AdditionalModelCopyWith<$Res> implements $AdditionalModelCopyWith<$Res> {
  factory _$AdditionalModelCopyWith(_AdditionalModel value, $Res Function(_AdditionalModel) _then) = __$AdditionalModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String type, String title, String content
});




}
/// @nodoc
class __$AdditionalModelCopyWithImpl<$Res>
    implements _$AdditionalModelCopyWith<$Res> {
  __$AdditionalModelCopyWithImpl(this._self, this._then);

  final _AdditionalModel _self;
  final $Res Function(_AdditionalModel) _then;

/// Create a copy of AdditionalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? content = null,}) {
  return _then(_AdditionalModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
