// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lexical_set_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LexicalSetModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'voc_id') int get vocId; String get title; String get translation; String get transcription;@JsonKey(name: 'set_title') String get setTitle; int get reward;
/// Create a copy of LexicalSetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LexicalSetModelCopyWith<LexicalSetModel> get copyWith => _$LexicalSetModelCopyWithImpl<LexicalSetModel>(this as LexicalSetModel, _$identity);

  /// Serializes this LexicalSetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LexicalSetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vocId, vocId) || other.vocId == vocId)&&(identical(other.title, title) || other.title == title)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.setTitle, setTitle) || other.setTitle == setTitle)&&(identical(other.reward, reward) || other.reward == reward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vocId,title,translation,transcription,setTitle,reward);

@override
String toString() {
  return 'LexicalSetModel(id: $id, vocId: $vocId, title: $title, translation: $translation, transcription: $transcription, setTitle: $setTitle, reward: $reward)';
}


}

/// @nodoc
abstract mixin class $LexicalSetModelCopyWith<$Res>  {
  factory $LexicalSetModelCopyWith(LexicalSetModel value, $Res Function(LexicalSetModel) _then) = _$LexicalSetModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'voc_id') int vocId, String title, String translation, String transcription,@JsonKey(name: 'set_title') String setTitle, int reward
});




}
/// @nodoc
class _$LexicalSetModelCopyWithImpl<$Res>
    implements $LexicalSetModelCopyWith<$Res> {
  _$LexicalSetModelCopyWithImpl(this._self, this._then);

  final LexicalSetModel _self;
  final $Res Function(LexicalSetModel) _then;

/// Create a copy of LexicalSetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vocId = null,Object? title = null,Object? translation = null,Object? transcription = null,Object? setTitle = null,Object? reward = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vocId: null == vocId ? _self.vocId : vocId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String,setTitle: null == setTitle ? _self.setTitle : setTitle // ignore: cast_nullable_to_non_nullable
as String,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LexicalSetModel].
extension LexicalSetModelPatterns on LexicalSetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LexicalSetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LexicalSetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LexicalSetModel value)  $default,){
final _that = this;
switch (_that) {
case _LexicalSetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LexicalSetModel value)?  $default,){
final _that = this;
switch (_that) {
case _LexicalSetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'voc_id')  int vocId,  String title,  String translation,  String transcription, @JsonKey(name: 'set_title')  String setTitle,  int reward)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LexicalSetModel() when $default != null:
return $default(_that.id,_that.vocId,_that.title,_that.translation,_that.transcription,_that.setTitle,_that.reward);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'voc_id')  int vocId,  String title,  String translation,  String transcription, @JsonKey(name: 'set_title')  String setTitle,  int reward)  $default,) {final _that = this;
switch (_that) {
case _LexicalSetModel():
return $default(_that.id,_that.vocId,_that.title,_that.translation,_that.transcription,_that.setTitle,_that.reward);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'voc_id')  int vocId,  String title,  String translation,  String transcription, @JsonKey(name: 'set_title')  String setTitle,  int reward)?  $default,) {final _that = this;
switch (_that) {
case _LexicalSetModel() when $default != null:
return $default(_that.id,_that.vocId,_that.title,_that.translation,_that.transcription,_that.setTitle,_that.reward);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LexicalSetModel implements LexicalSetModel {
  const _LexicalSetModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'voc_id') required this.vocId, required this.title, this.translation = '', this.transcription = '', @JsonKey(name: 'set_title') this.setTitle = '', this.reward = 0});
  factory _LexicalSetModel.fromJson(Map<String, dynamic> json) => _$LexicalSetModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'voc_id') final  int vocId;
@override final  String title;
@override@JsonKey() final  String translation;
@override@JsonKey() final  String transcription;
@override@JsonKey(name: 'set_title') final  String setTitle;
@override@JsonKey() final  int reward;

/// Create a copy of LexicalSetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LexicalSetModelCopyWith<_LexicalSetModel> get copyWith => __$LexicalSetModelCopyWithImpl<_LexicalSetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LexicalSetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LexicalSetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vocId, vocId) || other.vocId == vocId)&&(identical(other.title, title) || other.title == title)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.setTitle, setTitle) || other.setTitle == setTitle)&&(identical(other.reward, reward) || other.reward == reward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vocId,title,translation,transcription,setTitle,reward);

@override
String toString() {
  return 'LexicalSetModel(id: $id, vocId: $vocId, title: $title, translation: $translation, transcription: $transcription, setTitle: $setTitle, reward: $reward)';
}


}

/// @nodoc
abstract mixin class _$LexicalSetModelCopyWith<$Res> implements $LexicalSetModelCopyWith<$Res> {
  factory _$LexicalSetModelCopyWith(_LexicalSetModel value, $Res Function(_LexicalSetModel) _then) = __$LexicalSetModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'voc_id') int vocId, String title, String translation, String transcription,@JsonKey(name: 'set_title') String setTitle, int reward
});




}
/// @nodoc
class __$LexicalSetModelCopyWithImpl<$Res>
    implements _$LexicalSetModelCopyWith<$Res> {
  __$LexicalSetModelCopyWithImpl(this._self, this._then);

  final _LexicalSetModel _self;
  final $Res Function(_LexicalSetModel) _then;

/// Create a copy of LexicalSetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vocId = null,Object? title = null,Object? translation = null,Object? transcription = null,Object? setTitle = null,Object? reward = null,}) {
  return _then(_LexicalSetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vocId: null == vocId ? _self.vocId : vocId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String,setTitle: null == setTitle ? _self.setTitle : setTitle // ignore: cast_nullable_to_non_nullable
as String,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
