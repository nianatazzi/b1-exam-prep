// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theory_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TheoryModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'th_id') int get thId; String get topic; String get title; String get text; String? get video; int get duration; int get reward;
/// Create a copy of TheoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TheoryModelCopyWith<TheoryModel> get copyWith => _$TheoryModelCopyWithImpl<TheoryModel>(this as TheoryModel, _$identity);

  /// Serializes this TheoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TheoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.thId, thId) || other.thId == thId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&(identical(other.video, video) || other.video == video)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.reward, reward) || other.reward == reward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,thId,topic,title,text,video,duration,reward);

@override
String toString() {
  return 'TheoryModel(id: $id, thId: $thId, topic: $topic, title: $title, text: $text, video: $video, duration: $duration, reward: $reward)';
}


}

/// @nodoc
abstract mixin class $TheoryModelCopyWith<$Res>  {
  factory $TheoryModelCopyWith(TheoryModel value, $Res Function(TheoryModel) _then) = _$TheoryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'th_id') int thId, String topic, String title, String text, String? video, int duration, int reward
});




}
/// @nodoc
class _$TheoryModelCopyWithImpl<$Res>
    implements $TheoryModelCopyWith<$Res> {
  _$TheoryModelCopyWithImpl(this._self, this._then);

  final TheoryModel _self;
  final $Res Function(TheoryModel) _then;

/// Create a copy of TheoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? thId = null,Object? topic = null,Object? title = null,Object? text = null,Object? video = freezed,Object? duration = null,Object? reward = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,thId: null == thId ? _self.thId : thId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TheoryModel].
extension TheoryModelPatterns on TheoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TheoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TheoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TheoryModel value)  $default,){
final _that = this;
switch (_that) {
case _TheoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TheoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _TheoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'th_id')  int thId,  String topic,  String title,  String text,  String? video,  int duration,  int reward)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TheoryModel() when $default != null:
return $default(_that.id,_that.thId,_that.topic,_that.title,_that.text,_that.video,_that.duration,_that.reward);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'th_id')  int thId,  String topic,  String title,  String text,  String? video,  int duration,  int reward)  $default,) {final _that = this;
switch (_that) {
case _TheoryModel():
return $default(_that.id,_that.thId,_that.topic,_that.title,_that.text,_that.video,_that.duration,_that.reward);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'th_id')  int thId,  String topic,  String title,  String text,  String? video,  int duration,  int reward)?  $default,) {final _that = this;
switch (_that) {
case _TheoryModel() when $default != null:
return $default(_that.id,_that.thId,_that.topic,_that.title,_that.text,_that.video,_that.duration,_that.reward);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TheoryModel implements TheoryModel {
  const _TheoryModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'th_id') required this.thId, required this.topic, required this.title, required this.text, this.video, this.duration = 0, this.reward = 0});
  factory _TheoryModel.fromJson(Map<String, dynamic> json) => _$TheoryModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'th_id') final  int thId;
@override final  String topic;
@override final  String title;
@override final  String text;
@override final  String? video;
@override@JsonKey() final  int duration;
@override@JsonKey() final  int reward;

/// Create a copy of TheoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TheoryModelCopyWith<_TheoryModel> get copyWith => __$TheoryModelCopyWithImpl<_TheoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TheoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TheoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.thId, thId) || other.thId == thId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&(identical(other.video, video) || other.video == video)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.reward, reward) || other.reward == reward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,thId,topic,title,text,video,duration,reward);

@override
String toString() {
  return 'TheoryModel(id: $id, thId: $thId, topic: $topic, title: $title, text: $text, video: $video, duration: $duration, reward: $reward)';
}


}

/// @nodoc
abstract mixin class _$TheoryModelCopyWith<$Res> implements $TheoryModelCopyWith<$Res> {
  factory _$TheoryModelCopyWith(_TheoryModel value, $Res Function(_TheoryModel) _then) = __$TheoryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'th_id') int thId, String topic, String title, String text, String? video, int duration, int reward
});




}
/// @nodoc
class __$TheoryModelCopyWithImpl<$Res>
    implements _$TheoryModelCopyWith<$Res> {
  __$TheoryModelCopyWithImpl(this._self, this._then);

  final _TheoryModel _self;
  final $Res Function(_TheoryModel) _then;

/// Create a copy of TheoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? thId = null,Object? topic = null,Object? title = null,Object? text = null,Object? video = freezed,Object? duration = null,Object? reward = null,}) {
  return _then(_TheoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,thId: null == thId ? _self.thId : thId // ignore: cast_nullable_to_non_nullable
as int,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
